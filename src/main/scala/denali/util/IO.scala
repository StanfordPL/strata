package denali.util

import java.io.File
import java.lang.management.ManagementFactory
import scala.sys.process._
import ColoredOutput._

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
      line => res += line + "\n",
      line => res += line + "\n"
    )
    val process = Process(cmd, getProjectBase).run(logger)
    sys.addShutdownHook {
      process.destroy()
    }
    val status = process.exitValue()
    if (res.endsWith("\n")) {
      res = res.substring(0, res.length - 1)
    }
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
    println(s"ERROR: $msg".red)
    sys.exit(1)
  }

  /** Output an informational message. */
  def info(msg: String): Unit = {
    println(s"[  ] $msg")
  }

  /** Run a subcommand, show it's output and abort if it fails. */
  def subcommand(cmd: String): Unit = {
    val (out, status) = run(cmd)
    if (out.length != 0) {
      println(out.gray)
    }
    if (status != 0) {
      error(s"Command failed: $cmd")
    }
  }

  /** Returns an ID for the current execution context (host, process and thread). */
  def getExecContextId: String = {
    val host = "hostname".!!.stripLineEnd
    val pid: Int = ManagementFactory.getRuntimeMXBean.getName.split("@")(0).toInt
    val tid = Thread.currentThread().getId
    f"$host / $pid%06d-$tid%06d"
  }

  /** Read a file and return it's entire contents. */
  def readFile(file: File): String = {
    val source = scala.io.Source.fromFile(file)
    try source.getLines mkString "\n" finally source.close()
  }
}
