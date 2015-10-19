package denali.util

import java.io.{BufferedWriter, FileWriter, File}
import java.lang.management.ManagementFactory
import org.apache.commons.io.FileUtils
import org.joda.time.DateTime
import org.joda.time.format.DateTimeFormat

import scala.sys.process._
import ColoredOutput._

/**
 * A utility to run commands and capture their output.
 */
object IO {

  /** Return the current git hash. */
  def getGitHash: String = {
    val hash = "git rev-parse HEAD".!!
    hash.stripLineEnd
  }

  /**
   * Run a command and return it's output (stderr and stdout) and exit code.
   * Uses the base directory as working directory by default.
   */
  def run(cmd: Seq[Any], output_callback: String => Unit, err_callback: String => Unit, workingDirectory: File = null): (String, Int) = {
    var res = ""
    val logger = ProcessLogger(
      line => {
        res += line + "\n"
        output_callback(line + "\n")
      },
      line => {
        res += line + "\n"
        err_callback(line + "\n")
      }
    )
    val cwd = if (workingDirectory == null) getProjectBase else workingDirectory
    val process = Process(cmd map (x => x.toString), cwd).run(logger)
    val hook = sys.addShutdownHook {
      process.destroy()
    }
    val status = process.exitValue()
    hook.remove()
    if (res.endsWith("\n")) {
      res = res.substring(0, res.length - 1)
    }
    (res, status)
  }

  /**
   * Run a command and return it's output (stderr and stdout) and exit code.
   * Uses the base directory as working directory by default.
   */
  def runQuiet(cmd: Seq[Any], workingDirectory: File = null): (String, Int) = {
    run(cmd, x => (), x => (), workingDirectory = workingDirectory)
  }

  /**
   * Run a command and return it's output (stderr and stdout) and exit code.
   * Uses the base directory as working directory by default.
   */
  def runPrint(cmd: Seq[Any], workingDirectory: File = null): (String, Int) = {
    IO.info(s"Running command '${cmd2String(cmd)}'")
    run(cmd, s => print(s.gray), s => print(s.red), workingDirectory = workingDirectory)
  }

  /** Returns the base path of the whole project. */
  def getProjectBase: File = {
    var res = getClass.getResource("").getPath
    for (a <- 1 to 6) {
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
  def safeSubcommand(cmd: Seq[Any], workingDirectory: File = null): Unit = {
    val (out, status) = runPrint(cmd, workingDirectory = workingDirectory)
    if (status != 0) {
      error(s"Command failed: ${
        cmd2String(cmd)
      }")
    }
  }

  def cmd2String(cmd: Seq[Any]): String = {
    cmd.map(x => {
      if (x.toString.contains(" ")) {
        "\"" + x + "\""
      }
      else {
        x
      }
    }).mkString(" ")
  }

  /** Read a file and return it's entire contents. */
  def readFile(file: File): String = {
    val source = scala.io.Source.fromFile(file)
    try source.getLines mkString "\n" finally source.close()
  }

  /** Write a string to a file. */
  def writeFile(file: File, content: String, overwrite: Boolean = true): Unit = {
    if (overwrite && file.exists()) {
      assert(file.delete())
    }
    assert(!file.exists())
    val bw = new BufferedWriter(new FileWriter(file))
    bw.write(content)
    bw.close()
  }

  /** Copy a file. */
  def copyFile(a: File, b: File): Unit = {
    FileUtils.copyFile(a, b)
  }

  /** Format a DateTime nicely. */
  def formatTime(time: DateTime): String = {
    DateTimeFormat.forPattern("YYYY-MM-dd HH:mm:ss").print(time)
  }
}
