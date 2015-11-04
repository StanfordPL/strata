package strata.tasks

import java.io.{File, FileWriter}

import strata.data._
import strata.util.{IO, TimingBuilder}

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

    val testcases = new File(s"$tmpDir/testcases.tc")
    val stoke = Stoke(tmpDir, meta, instr, state, timing)

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

    /** Add a counterexample to the list of tests, and then re-test all programs. */
    def addCounterexample(verifyRes: StokeVerifyOutput): (Seq[String], Seq[String]) = {
      // add counterexample to tests
      state.lockedInformation(() => {
        addTestcase(state.getTestcasePath, verifyRes.counterexample)
        // get an up-to-date copy of the testcases
        testcases.delete()
        IO.copyFile(state.getTestcasePath, testcases)
      })
      val correct = collection.mutable.ListBuffer.empty[String]
      val incorrect = collection.mutable.ListBuffer.empty[String]
      // run tests on all programs
      for (candidate <- state.getResultFiles(instr)) {
        stoke.verify(state.getTargetOfInstr(instr), candidate, useFormal = false) match {
          case None =>
            // this should not happen, but remove this program
            val file = state.getFreshDiscardedName("error", instr)
            IO.moveFile(candidate, file)
            incorrect += file.getName
          case Some(testResult) =>
            if (testResult.isVerified) {
              // keep the program
              correct += candidate.getName
            } else {
              // this program is definitely wrong, let's remove it
              val file = state.getFreshDiscardedName("counterexample", instr)
              IO.moveFile(candidate, file)
              incorrect += file.getName
            }
        }
      }
      (correct, incorrect)
    }

    try {
      val nBase = stoke.initSearch()
      val result = stoke.search(budget, useNonGoal = true)
      result match {
        case None =>
          state.appendLog(LogError(s"no result for secondary search of $instr"))
          SecondarySearchError(task, timing.result)
        case Some(res) =>
          // update meta
          val more = SecondarySearchMeta(if (res.success && res.verified) 1 else 0,
            budget, res.statistics.total_iterations, nBase)
          meta = meta.copy(secondary_searches = meta.secondary_searches ++ Vector(more))
          state.writeMetaOfInstr(instr, meta)

          if (!(res.success && res.verified)) {
            return SecondarySearchTimeout(task, timing.result)
          } else {

            val resultFile = state.getFreshResultName(instr)
            // move result to result folder
            IO.copyFile(new File(s"$tmpDir/result.s"), resultFile)

            // we should have found at least one program
            val beforeEqClasses = meta.equivalence_classes
            assert(beforeEqClasses.nClasses > 0)

            // go through all equivalence classes, and attempt to prove it against a representative program
            val score = Stoke.determineHeuristicScore(state, instr, Some(resultFile))
            val newProgram = EvaluatedProgram(resultFile.getName, score)
            def loop(remaining: Seq[EquivalenceClass], tail: Seq[EquivalenceClass]): (SecondarySearchResult, Seq[EquivalenceClass]) = {
              remaining match {
                case Nil =>
                  // case 0: was not the same as any equivalence class: create a new equivalence class
                  val res = SecondarySearchSuccess(task, SrkUnknown(tail.size), timing.result)
                  (res, Vector(newProgram.asEquivalenceClass) ++ tail)
                case x :: xs =>
                  // case 1: compare formally against this equivalence class
                  val file = x.getRepresentativeProgram.getFile(instr, state)
                  stoke.verify(resultFile, file, useFormal = true) match {
                    case Some(verifyRes) =>

                      // case 1a: we found an equivalent program in x
                      if (verifyRes.isVerified) {
                        // add to the equivalence class
                        val eq = xs ++ tail ++ Vector(EquivalenceClass(x.programs ++ Vector(newProgram)))
                        state.writeMetaOfInstr(instr, meta)
                        val res = SecondarySearchSuccess(task, SrkEquivalent(), timing.result)
                        (res, eq)
                      }

                      // case 1b: we found a counterexample
                      else if (verifyRes.isCounterExample) {
                        val (correct, incorrect) = addCounterexample(verifyRes)
                        if (correct.isEmpty) {
                          throw new RuntimeException(s"everything was wrong: $correct, $incorrect")
                        }
                        val res = SecondarySearchSuccess(task, SrkCounterExample(correct, incorrect), timing.result)
                        val beforePlusNew = Vector(newProgram.asEquivalenceClass) ++ beforeEqClasses.getClasses()
                        val eq = beforePlusNew.flatMap(eq => eq.filterExisting(instr, state))
                        if (correct.length != eq.map(x => x.size).sum) {
                          throw new RuntimeException(
                            s"didn't keep the necessary programs: $correct, $incorrect, $beforeEqClasses, $eq")
                        }
                        (res, eq)
                      }

                      // case 1c: unknown
                      else {
                        // keep going
                        loop(xs, Vector(x) ++ tail)
                      }
                    case None =>
                      // case 1c: unknown
                      loop(xs, Vector(x) ++ tail)
                  }
              }
            }

            val (res, newEq) = loop(beforeEqClasses.getClasses(), Nil)

            meta = meta.copy(equivalence_classes = EquivalenceClasses(newEq))
            state.writeMetaOfInstr(instr, meta)

            res
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
