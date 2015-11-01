package strata.data

import java.io.File

import strata.util.{TimingBuilder, TimingKind, IO}
import org.json4s._
import org.json4s.native.JsonMethods._
import strata.util.ColoredOutput._

/**
 * Various utility functionality for dealing with STOKE.
 */
object Stoke {

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
  def determineHeuristicScore(state: State, instr: Instruction, program: File): Score = {
    val resCircuit = new File(s"${state.getCircuitDir}/$instr.s")
    IO.copyFile(program, resCircuit)
    val cmd = Vector(s"${IO.getProjectBase}/stoke/bin/specgen", "evaluate",
      "--circuit_dir", state.getCircuitDir,
      "--opcode", instr)
    val (out, status) = IO.runQuiet(cmd)
    if (status != 0) {
      throw new RuntimeException(s"specgen_evaluate failed: $out")
    }
    val outParsed = out.trim.split(",").map(_.toInt)
    assert(outParsed.length == 3)
    resCircuit.delete()
    Score(outParsed(0), outParsed(1), outParsed(2))
  }


}

case class Verifier(tmpDir: File, meta: InstructionMeta, instr: Instruction, state: State, timing: TimingBuilder) {

  /**
   * Take two programs and compare them.  Returns a verification result only if there was no error.
   */
  def stokeVerify(a: File, b: File, useFormal: Boolean): Option[StokeVerifyOutput] = {
    val testcases = new File(s"$tmpDir/testcases.tc")
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
}

case class Score(uif: Int, mult: Int, nodes: Int) extends Ordered[Score] {
  // lexographical ordering
  def compare(that: Score): Int = {
    for((x,y) <- data zip that.data) {
        val c = x compare y
        if(c != 0) return c
      }
      data.size - that.data.size
    }
  private def data = Vector(uif, mult, nodes)
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

  /** Was there an error during verification?*/
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
