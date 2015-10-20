package denali.data

import java.io.File

import denali.util.IO
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
