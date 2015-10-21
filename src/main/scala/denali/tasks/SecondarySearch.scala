package denali.tasks

import java.io.{FileWriter, File}

import denali.data._
import denali.util.ColoredOutput._
import denali.util.{Timing, TimingKind, TimingBuilder, IO}

/**
 * Perform an secondary search for a given instruction.
 */
object SecondarySearch {
  def run(task: SecondarySearchTask): SecondarySearchResult = {
    val timing = TimingBuilder()
    val globalOptions = task.globalOptions
    val state = State(globalOptions)
    val workdir = globalOptions.workdir

    val instr = task.instruction
    val budget = task.budget
    var meta = state.getMetaOfInstr(instr)

    // set up tmp dir
    val tmpDir = new File(s"${state.getTmpDir}/${ThreadContext.self.fileNameSafe}")
    tmpDir.mkdir()

    /** Takes a testcase file and appends a new testcase. */
    def addTestcase(tcFile: File, testcase: String): Unit = {
      val buf = scala.io.Source.fromFile(tcFile)
      val Pattern = "Testcase ([0-9]*):".r
      val nTests = (buf.getLines().collect({
        case Pattern(c) => c.toInt
      }) ++ Vector(-1)).max
      buf.close()
      val fw = new FileWriter(tcFile, true)
      try {
        fw.write(s"\n\nTestcase ${nTests + 1}:\n\n")
        fw.write(testcase.stripLineEnd)
        fw.write("\n")
      }
      finally {
        fw.close()
      }
    }

    /**
     * Take two programs and compare them formally.  Returns a verification result only if there was no error.
     */
    def stokeVerify(a: File, b: File, useFormal: Boolean): Option[StokeVerifyOutput] = {
      val (_, res) = timing.timeOperation(if (useFormal) TimingKind.Verification else TimingKind.Testing)({
        val cmd = Vector("timeout", "15s",
          s"${IO.getProjectBase}/stoke/bin/stoke", "debug", "verify",
          "--config", s"${IO.getProjectBase}/resources/conf-files/formal.conf",
          "--target", a,
          "--rewrite", b,
          "--strategy", if (useFormal) "bounded" else "hold_out",
          "--def_in", meta.def_in_formal,
          "--live_out", meta.live_out_formal,
          "--strata_path", state.getCircuitDir,
          "--functions", s"$workdir/functions",
          "--machine_output", "verify.json")
        if (globalOptions.verbose) {
          IO.runPrint(cmd, workingDirectory = tmpDir)
        } else {
          IO.runQuiet(cmd, workingDirectory = tmpDir)
        }
      })

      if (res == 124) {
        // a timeout happened
        val verifyRes = StokeVerifyOutput.makeTimeout
        state.appendLog(LogVerifyResult(instr, useFormal, verifyRes, IO.contentHash(a), IO.contentHash(a)))
        Some(verifyRes)
      } else {
        Stoke.readStokeVerifyOutput(new File(s"$tmpDir/verify.json")) match {
          case None =>
            state.appendLog(LogError(s"no result for stoke verify of $instr"))
            IO.info(s"stoke verify failed to produce an output (useformal = $useFormal)".red)
            None
          case Some(verifyRes) if verifyRes.hasError =>
            val message = s"stoke verify errored with ${verifyRes.error} for $instr (useformal = $useFormal)"
            state.appendLog(LogError(message))
            state.appendLog(LogVerifyResult(instr, useFormal, verifyRes, IO.contentHash(a), IO.contentHash(a)))
            IO.info(message.red)
            None
          case Some(verifyRes) =>
            state.appendLog(LogVerifyResult(instr, useFormal, verifyRes, IO.contentHash(a), IO.contentHash(a)))
            Some(verifyRes)
        }
      }
    }

    /** Add a counterexample to the list of tests, and then re-test all programs. */
    def addCounterexample(verifyRes: StokeVerifyOutput): (Int, Int) = {
      var equiv = meta.equivalent_programs
      // add counterexample to tests
      state.lockedInformation(() => {
        addTestcase(state.getTestcasePath, verifyRes.counterexample)
      })
      var correct = 0
      var incorrect = 0
      // run tests on all programs
      for (candidate <- state.getResultFiles(instr)) {
        stokeVerify(state.getTargetOfInstr(instr), candidate, useFormal = false) match {
          case None =>
            // this should not happen, but remove this program
            IO.moveFile(candidate, state.getFreshDiscardedName("error", instr))
            equiv = equiv.filter(p => p != candidate.getName)
            incorrect += 1
          case Some(testResult) =>
            if (testResult.isVerified) {
              // keep the program
              correct += 1
            } else {
              // this program is definitely wrong, let's remove it
              IO.moveFile(candidate, state.getFreshDiscardedName("counterexample", instr))
              equiv = equiv.filter(p => p != candidate.getName)
              incorrect +=1
            }
        }
      }
      meta = meta.copy(equivalent_programs = equiv)
      state.writeMetaOfInstr(instr, meta)
      (correct, incorrect)
    }

    try {
      val testcases = new File(s"$tmpDir/testcases.tc")
      val base = state.lockedInformation(() => {
        // copy the tests to the local directory
        IO.copyFile(state.getTestcasePath, testcases)

        // get the base instructions
        state.getInstructionFile(InstructionFile.Success)
      })
      val baseConfig = new File(s"$tmpDir/base.conf")
      IO.writeFile(baseConfig, "--opc_whitelist \"{ " + base.mkString(" ") + " }\"\n")
      timing.timeOperation(TimingKind.Search)({
        val cmd = Vector(s"${IO.getProjectBase}/stoke/bin/stoke", "search",
          "--config", s"${IO.getProjectBase}/resources/conf-files/search.conf",
          "--config", baseConfig,
          "--target", state.getTargetOfInstr(instr),
          "--def_in", meta.def_in,
          "--live_out", meta.live_out,
          "--functions", s"$workdir/functions",
          "--testcases", testcases,
          "--machine_output", "search.json",
          "--call_weight", state.getNumPseudoInstr,
          "--timeout_iterations", budget,
          "--non_goal", state.getInstructionResultDir(instr),
          "--cost", "correctness + nongoal",
          "--correctness", "(correctness + nongoal) == 0")
        if (globalOptions.verbose) {
          IO.runPrint(cmd, workingDirectory = tmpDir)
        } else {
          IO.runQuiet(cmd, workingDirectory = tmpDir)
        }
      })
      Stoke.readStokeSearchOutput(new File(s"$tmpDir/search.json")) match {
        case None =>
          state.appendLog(LogError(s"no result for secondary search of $instr"))
          IO.info("stoke failed".red)
          SecondarySearchError(task, timing.result)
        case Some(res) =>
          // update meta
          val more = SecondarySearchMeta(if (res.success && res.verified) 1 else 0,
            budget, res.statistics.total_iterations, base.length)
          meta = meta.copy(secondary_searches = meta.secondary_searches ++ Vector(more))
          state.writeMetaOfInstr(instr, meta)

          if (!(res.success && res.verified)) {
            return SecondarySearchTimeout(task, timing.result)
          } else {

            val resultFile = state.getFreshResultName(instr)
            // move result to result folder
            IO.copyFile(new File(s"$tmpDir/result.s"), resultFile)

            // case 1: we have not found any equivalent programs
            if (meta.equivalent_programs.isEmpty) {
              // try all previously found programs
              val resultFiles = state.getResultFiles(instr)
              for (previousRes <- resultFiles if previousRes != resultFile) {
                stokeVerify(resultFile, previousRes, useFormal = true) match {
                  case None => // just ignore this error and try the next one
                  case Some(verifyRes) =>

                    // case 1a: we found an equivalent program
                    if (verifyRes.isVerified) {
                      // add both programs to the list of known equivalent programs
                      meta = meta.copy(equivalent_programs = Vector(previousRes.getName, resultFile.getName))
                      state.writeMetaOfInstr(instr, meta)
                      return SecondarySearchSuccess(task, SrkEquivalent(), timing.result)
                    }

                    // case 1b: we found a counterexample
                    else if (verifyRes.isCounterExample) {
                      val (correct, incorrect) = addCounterexample(verifyRes)
                      return SecondarySearchSuccess(task, SrkCounterExample(correct, incorrect), timing.result)
                    }
                }
              }
              // case 1c: we only got unknown answers
              return SecondarySearchSuccess(task, SrkUnknown(resultFiles.length, againstEquiv = false), timing.result)
            }

            // case 2: we already have a set of equivalent programs
            else {
              // take one of them and verify formally
              stokeVerify(resultFile, meta.getEquivProgram(instr, state), useFormal = true) match {
                case None =>
                  // an error happened
                  IO.moveFile(resultFile, state.getFreshDiscardedName("error", instr))
                  return SecondarySearchSuccess(task, SrkUnknown(1, againstEquiv = true), timing.result)
                case Some(verifyRes) =>
                  if (verifyRes.isVerified) {
                    // case 2a: verified: add the verified program to the list
                    meta = meta.copy(equivalent_programs = meta.equivalent_programs ++ Vector(resultFile.getName))
                    state.writeMetaOfInstr(instr, meta)
                    return SecondarySearchSuccess(task, SrkEquivalent(), timing.result)
                  } else if (verifyRes.isUnknown) {
                    // case 2b: unknown: keep the program, but don't add it to the set of eqiv programs
                    return SecondarySearchSuccess(task, SrkUnknown(1, againstEquiv = true), timing.result)
                  } else {
                    assert(verifyRes.isCounterExample)
                    // case 2c: counterexample
                    val (correct, incorrect) = addCounterexample(verifyRes)
                    return SecondarySearchSuccess(task, SrkCounterExample(correct, incorrect), timing.result)
                  }
              }
            }
          }
      }
    } finally {
      // tear down tmp dir
      if (!globalOptions.keepTmpDirs) {
        IO.deleteDirectory(tmpDir)
      }
    }
  }
}
