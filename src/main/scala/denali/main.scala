package denali

import java.io.File

import denali.data.{Config, Instruction}
import denali.util.IO

import scala.io.Source

/**
 * Main entry point.
 */
object Denali {
  def main(args: Array[String]) {

    val shortDescription = "Automatic inference of a formal specification of the x86_64 instruction set"

    def addGlobalOptions[T](parser: scopt.OptionParser[T], command: String, updateGlobal: (File, T) => T): Unit = {
      parser.help("help") text s"Usage information for the $command command"
      parser.opt[File]('w', "workdir") valueName ("<dir>") action {
        (x, c) => updateGlobal(x, c)
      } text (s"The directory where outputs and intermediate progress are stored. Default: ${GlobalOptions().workdir}")
    }

    val commands: List[(String, String, (Array[String], String) => Unit)] = List(
      ("init", "Initialize the configuration for denali", (localArgs: Array[String], helpStr: String) => {
        val parser = new scopt.OptionParser[InitOptions]("denali") {
          head(shortDescription)
          note(helpStr)

          addGlobalOptions(this, "init", (x, c: InitOptions) => c.copy(globalOptions = c.globalOptions.copy(workdir = x)))
        }
        parser.parse(localArgs, InitOptions(GlobalOptions())) match {
          case Some(c) =>
            Initialize.run(args, c)
          case None =>
          // arguments are bad, error message will have been displayed
        }
      }),

      ("step", "Take one more step towards finding the right specification", (localArgs: Array[String], helpStr: String) => {
        val parser = new scopt.OptionParser[InitialSearchOptions]("denali") {
          head(shortDescription)
          note(helpStr)

          addGlobalOptions(this, "step", (x, c: InitialSearchOptions) => c.copy(globalOptions = c.globalOptions.copy(workdir = x)))
        }
        parser.parse(localArgs, InitialSearchOptions(GlobalOptions(), null, 0)) match {
          case Some(c) =>
            Config(c.globalOptions).appendLog(s"Entry point: denali ${args.mkString(" ")}")
            InitialSearch.run(c)
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

case class InitialSearchOptions(globalOptions: GlobalOptions,
                                instruction: Instruction,
                                budget: Int)
