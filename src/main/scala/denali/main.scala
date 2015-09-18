package denali

import java.io.File

import denali.data.Instruction
import denali.util.IO

import scala.io.Source

/**
 * Main entry point.
 */
object Denali {
  def main(args: Array[String]) {

    val shortDescription = "Automatic inference of a formal specification of the x86_64 instruction set"

    val commands: List[(String, String, (Array[String], String) => Unit)] = List(
      ("init", "Initialize the configuration for denali", (args: Array[String], helpStr: String) => {
        val parser = new scopt.OptionParser[InitOptions]("denali") {
          head(shortDescription)
          help("help") text "Usage information for the init command"

          note(helpStr)
          opt[File]('w', "workdir") valueName ("<dir>") action {
            (x, c) => c.copy(globalOptions = c.globalOptions.copy(workdir = x))
          } text (s"The directory where outputs and intermediate progress are stored. Default: ${GlobalOptions().workdir}")
        }
        parser.parse(args.slice(1, args.length), InitOptions(GlobalOptions())) match {
          case Some(c) =>
            Initialize.run(c)
          case None =>
          // arguments are bad, error message will have been displayed
        }
      })
    )

    if (args(0) == "-h" || args(0) == "--help") {
      showHelp(shortDescription, commands)
      return
    }

    for (c <- commands) {
      if (args(0) == c._1) {
        c._3(args.slice(1, args.length), c._2)
      }
    }

    println(s"Command '${args(0)}' not found.\n")
    showHelp(shortDescription, commands)
    sys.exit(1)
  }

  def showHelp(shortDescription: String, commands: List[(String, String, (Array[String], String) => Unit)]): Unit = {
    println("usage: denali [-h/--help] <command> [options]")
    println()
    println(shortDescription)
    println()
    println("Available commands:")
    val max = (commands map (x => x._1.length)).max
    for (c <- commands) {
      print("  ")
      print(c._1)
      print(" " * (max - c._1.length + 3))
      print(c._2)
      println()
    }
    println()
    println("Use 'denali <command> --help' to see the available options for a given command.")
  }
}

/**
 * Command line argument class.
 */
case class GlobalOptions(workdir: File = new File(s"${System.getProperty("user.home")}/dev/denali-output"),
                         showStokeOutput: Boolean = false) {

  /** Create an instruction and check that it actually exists. */
  def mkInstruction(opcode: String): Instruction = {
    val file = Source.fromFile(s"$workdir/config/all.txt")
    try {
      for (o <- file.getLines()) {
        if (o == opcode) return new Instruction(opcode, this)
      }
      IO.error(s"Could not find the opcode '$opcode'.")
    } finally {
      file.close()
    }
  }
}

case class InitOptions(globalOptions: GlobalOptions)