package strata.data

import java.io.File

import org.json4s._
import org.json4s.native.JsonMethods._
import strata.util.{IO, Sorting, TimingBuilder, TimingKind}

/**
 * Various utility functionality for dealing with STOKE.
 */
object Stoke {

  /** Is this result "false" (i.e. a bug). */
  def isFalseResult(res: StokeSearchOutput): Boolean = {
    !res.success && !res.verified && !res.timeout && res.statistics.total_iterations == 0
  }

  /** Parse the machine-readable output of `stoke search`. */
  def readStokeSearchOutput(machineOutput: File): Option[StokeSearchOutput] = {
    try {
      implicit val formats = DefaultFormats
      Some(parse(IO.readFile(machineOutput)).extract[StokeSearchOutput])
    } catch {
      case _: Throwable => None
    }
  }

  /** Parse the machine-readable output of `stoke search`. */
  def readStokeVerifyOutput(machineOutput: File): Option[StokeVerifyOutput] = {
    try {
      implicit val formats = DefaultFormats
      Some(parse(IO.readFile(machineOutput)).extract[StokeVerifyOutput])
    } catch {
      case _: Throwable => None
    }
  }

  /** Compute the heuristic (how many uninterpreted functions/multiplications/nodes does the corresponding circuit use?). */
  def determineHeuristicScore(state: State, instr: Instruction, program: Option[File] = None): Score = {
    val resFile = if (program.isDefined) {
      val resCircuit = new File(s"${state.getCircuitDir}/$instr.s")
      IO.copyFile(program.get, resCircuit)
      Some(resCircuit)
    } else {
      None
    }
    val cmd = Vector(s"${IO.getProjectBase}/stoke/bin/specgen", "evaluate",
      "--circuit_dir", state.getCircuitDir,
      "--opcode", instr)
    val (out, status) = IO.runQuiet(cmd)
    if (status != 0) {
      throw new RuntimeException(s"specgen_evaluate failed with for $instr (call ${IO.cmd2String(cmd)}}) $status: $out")
    }
    val outParsed = out.trim.split(",").map(_.toInt)
    assert(outParsed.length == 3)
    resFile.map(f => f.delete())
    Score(outParsed(0), outParsed(1), outParsed(2))
  }
}

/** Helper class to run stoke commands. */
case class Stoke(tmpDir: File, meta: InstructionMeta, instr: Instruction, state: State, timing: TimingBuilder) {

  private val baseConfig = new File(s"$tmpDir/base.conf")
  private val testcases = new File(s"$tmpDir/testcases.tc")

  /** Copies the testcases and gets the current whitelist of instructions. */
  def initSearch(): Int = {
    val testcases = new File(s"$tmpDir/testcases.tc")
    val base = state.lockedInformation(() => {
      // copy the tests to the local directory
      IO.copyFile(state.getTestcasePath, testcases)

      // get the base instructions
      val success = if (instr.isImm8Instr) {
        // for imm8 instructions, we just use the base
        state.getInstructionFile(InstructionFile.Base)
      } else {
        state.getInstructionFile(InstructionFile.Success)
      }

      if (meta.search_without_uif) {
        state.updateUifCache()
        success.filter(i => !state.usesUIF(i, useCache = true))
      } else {
        success
      }
    })

    IO.writeFile(baseConfig, "--opc_whitelist \"{ " + base.mkString(" ") + " }\"\n")
    base.length
  }

  /** Actually perform a search. */
  def search(budget: Long, useNonGoal: Boolean): Option[StokeSearchOutput] = {
    val (out, _) = timing.timeOperation(TimingKind.Search)({
      val cost = if (useNonGoal) {
        Vector("--non_goal", state.getInstructionResultDir(instr),
          "--cost", "correctness + nongoal",
          "--correctness", "(correctness + nongoal) == 0")
      } else {
        Vector("--cost", "correctness")
      }
      val cmd = Vector(s"${IO.getProjectBase}/stoke/bin/stoke", "search",
        "--config", s"${IO.getProjectBase}/resources/conf-files/search.conf",
        "--config", baseConfig,
        "--target", state.getTargetOfInstr(instr),
        "--def_in", meta.def_in,
        "--live_out", meta.live_out,
        "--functions", s"${state.globalOptions.workdir}/functions",
        "--testcases", testcases,
        "--machine_output", "search.json",
        "--call_weight", state.getNumPseudoInstr,
        "--timeout_iterations", budget) ++ cost
      if (state.globalOptions.verbose) {
        IO.runPrint(cmd, workingDirectory = tmpDir)
      } else {
        IO.runQuiet(cmd, workingDirectory = tmpDir)
      }
    })
    val res = Stoke.readStokeSearchOutput(new File(s"$tmpDir/search.json"))
    res match {
      case Some(searchRes) if searchRes.success =>
        // search finished successfully. run tests to make sure we didn't find a bogus program
        // this shouldn't be necessary, but helps us catch bugs
        val file = new File(s"$tmpDir/result.s")
        assert(file.exists())
        verify(file, state.getTargetOfInstr(instr), useFormal = false) match {
          case None =>
            assert(false)
          case Some(verifyOutput) =>
            if (!verifyOutput.isVerified) {
              // this should NOT happen
              state.appendLog(LogSearchBug(instr, meta.def_in, meta.live_out, out))
              // pretend the search failed
              val p = StokeCode(0, "")
              val stats = StokeSearchStatistics(0, 0, 0, 0)
              return Some(StokeSearchOutput(success = false, interrupted = false, timeout = false, verified = false, stats, p, p))
            }
        }
      case _ =>
    }
    res
  }

  /**
   * Take two programs and compare them.  Returns a verification result only if there was no error.
   */
  def verify(a: File, b: File, useFormal: Boolean): Option[StokeVerifyOutput] = {
    val (_, res) = timing.timeOperation(if (useFormal) TimingKind.Verification else TimingKind.Testing)({
      val cmd = Vector("timeout", "60s",
        s"${IO.getProjectBase}/stoke/bin/stoke", "debug", "verify",
        "--config", s"${IO.getProjectBase}/resources/conf-files/formal.conf",
        "--target", a,
        "--rewrite", b,
        "--testcases", testcases,
        "--strategy", if (useFormal) "bounded" else "hold_out",
        "--def_in", meta.def_in_formal,
        "--live_out", meta.live_out_formal,
        "--strata_path", state.getCircuitDir,
        "--functions", s"${state.globalOptions.workdir}/functions",
        "--machine_output", "verify.json")
      if (state.globalOptions.verbose) {
        IO.runPrint(cmd, workingDirectory = tmpDir)
      } else {
        IO.runQuiet(cmd, workingDirectory = tmpDir)
      }
    })

    if (res == 124) {
      // a timeout happened
      val verifyRes = StokeVerifyOutput.makeTimeout
      state.appendLog(LogVerifyResult(instr, useFormal, verifyRes, a.getName, b.getName))
      Some(verifyRes)
    } else {
      Stoke.readStokeVerifyOutput(new File(s"$tmpDir/verify.json")) match {
        case None =>
          state.appendLog(LogError(s"no result for stoke verify of $instr (useformal = $useFormal)"))
          None
        case Some(verifyRes) if verifyRes.hasError =>
          val message = s"stoke verify errored with ${verifyRes.error} for $instr (useformal = $useFormal)"
          state.appendLog(LogError(message))
          state.appendLog(LogVerifyResult(instr, useFormal, verifyRes, a.getName, b.getName))
          None
        case Some(verifyRes) =>
          state.appendLog(LogVerifyResult(instr, useFormal, verifyRes, a.getName, b.getName))
          Some(verifyRes)
      }
    }
  }
}

case class Score(uif: Int, mult: Int, nodes: Int) extends Ordered[Score] {
  // lexographical ordering
  def compare(that: Score): Int = Sorting.lexographicalCompare(data, that.data)

  def data = Vector(uif, mult, nodes)

  override def toString = s"($uif, $mult, $nodes)"
}

case class StokeSearchOutput(
                              success: Boolean,
                              interrupted: Boolean,
                              timeout: Boolean,
                              verified: Boolean,
                              statistics: StokeSearchStatistics,
                              best_yet: StokeCode,
                              best_correct: StokeCode
                              )

case class StokeCode(cost: Long, code: String)

case class StokeSearchStatistics(
                                  total_iterations: Long,
                                  total_attempted_searches: Long,
                                  total_search_time: Double,
                                  total_time: Double
                                  )

case class StokeVerifyOutput(
                              verified: Boolean,
                              counter_examples_available: Boolean,
                              counterexample: String,
                              error: String
                              ) {
  // uses a hack to store '__timeout__' in error to indicate timeouts
  // NOTE: exactly one of the isX methods will return true

  /** Was there an error during verification? */
  def hasError = error != "" && error != "__timeout__"

  /** Successfully verified? */
  def isVerified = verified

  /** Did the SMT solver say no, but not provide a (valid) counterexample? */
  def isUnknown = !verified && !counter_examples_available && !isTimeout

  /** Is there a counterexample. */
  def isCounterExample = counter_examples_available

  /** Was there a timeout? */
  def isTimeout = error == "__timeout__"
}

object StokeVerifyOutput {
  def makeTimeout = StokeVerifyOutput(verified = false, counter_examples_available = false, "", "__timeout__")
}
