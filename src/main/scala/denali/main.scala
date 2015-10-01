package denali

import java.io.File

import denali.data.{State, Instruction}
import denali.tasks.InitialSearch
import denali.util.IO

import scala.io.Source

/**
 * Main entry point.
 */
object Denali {
  def main(args: Array[String]) {

    implicit val InstructionRead: scopt.Read[Instruction] = scopt.Read.reads(x => Instruction(x))

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
            sys.exit(1)
        }
      }),

      ("run", "A full run of denali", (localArgs: Array[String], helpStr: String) => {
        val parser = new scopt.OptionParser[GlobalOptions]("denali") {
          head(shortDescription)
          note(helpStr)

          addGlobalOptions(this, "init", (x, c: GlobalOptions) => c.copy(workdir = x))
        }
        parser.parse(localArgs, GlobalOptions()) match {
          case Some(c) =>
            Driver(c).run(args)
          case None =>
            // arguments are bad, error message will have been displayed
            sys.exit(1)
        }
      }),

      ("step", "Take one more step towards finding the right specification", (localArgs: Array[String], helpStr: String) => {
        var instr: Option[Instruction] = None
        val parser = new scopt.OptionParser[GlobalOptions]("denali") {
          head(shortDescription)
          note(helpStr)

          addGlobalOptions(this, "init", (x, c: GlobalOptions) => c.copy(workdir = x))
          opt[Instruction]("instr") valueName ("<opcode>") action {
            (x, c: GlobalOptions) => {
              instr = Some(x)
              c
            }
          } text (s"The instruction that should be processed next.")
        }
        parser.parse(localArgs, GlobalOptions()) match {
          case Some(c) =>
            State(c).appendLog(s"Entry point: denali ${args.mkString(" ")}")
            val driver = Driver(c)
            driver.selectNextTask(instr) match {
              case None =>
                IO.info("No task available")
              case Some(t) =>
                IO.info(s"Selected task '$t'")
                val res = driver.runTask(t)
                driver.handleTaskResult(res)
            }
          case None =>
            // arguments are bad, error message will have been displayed
            sys.exit(1)
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
        return
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
case class GlobalOptions(workdir: File = new File(s"${System.getProperty("user.home")}/dev/output-denali"),
                         showStokeOutput: Boolean = false)

case class InitOptions(globalOptions: GlobalOptions)
