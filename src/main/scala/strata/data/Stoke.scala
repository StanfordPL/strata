package strata.data

import java.io.File

import strata.util.IO
import org.json4s._
import org.json4s.native.JsonMethods._

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
