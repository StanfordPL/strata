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