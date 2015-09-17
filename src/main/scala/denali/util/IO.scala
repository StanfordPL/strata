package denali.util

import java.io.File
import java.nio.file.Path

import scala.sys.process._

/**
 * A utility to run commands and capture their output.
 */
object IO {

  /**
   * Run a command and return it's output (stderr and stdout) and exit code.
   * Uses the base directory as working directory.
   */
  def run(cmd: String): (String, Int) = {
    var res = ""
    val logger = ProcessLogger(
      line => res += line,
      line => res += line
    )
    val status = Process(cmd, getProjectBase) ! logger
    (res, status)
  }

  /** Returns the base path of the whole project. */
  def getProjectBase: File = {
    var res = getClass.getResource("").getPath
    for( a <- 1 to 6){
      res = res.substring(0, res.lastIndexOf('/'))
    }
    new File(res)
  }

  /** Output an error message and exit. */
  def error(msg: String): Nothing = {
    println(s"ERROR: $msg")
    sys.exit(1)
  }
}
