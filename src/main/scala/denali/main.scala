package denali

import java.io.File
import java.util.Date

import denali.data._
import denali.tasks.InitialSearch
import denali.util.IO

import scala.io.Source

/**
 * Main entry point.
 */
object Denali {
  def main(args: Array[String]) {

//    Log.test()
//    return

    implicit val InstructionRead: scopt.Read[Instruction] = scopt.Read.reads(x => Instruction(x))

    val shortDescription = "Automatic inference of a formal specification of the x86_64 instruction set"

    def addGlobalOptions[T](parser: scopt.OptionParser[T], command: String,
                            updateGlobal: (Option[File], Option[Boolean], Option[Boolean], T) => T): Unit = {
      parser.help("help") text s"Usage information for the $command command"
      parser.opt[File]('w', "workdir") valueName ("<dir>") action {
        (x, c) => updateGlobal(Some(x), None, None, c)
      } text (s"The directory where outputs and intermediate progress are stored. Default: ${GlobalOptions().workdir}")
      parser.opt[Unit]('v', "verbose") action {
        (x, c) => updateGlobal(None, Some(true), None, c)
      } text (s"Verbose output.  Default: ${GlobalOptions().verbose}")
      parser.opt[Unit]('v', "keepTmpDirs") action {
        (x, c) => updateGlobal(None, None, Some(true), c)
      } text (s"Keep the temporary working directories intact.  Default: ${GlobalOptions().verbose}")
    }
    def normalUpdateGlobal(workdir: Option[File], verbose: Option[Boolean], keepTmpDirs: Option[Boolean], c: GlobalOptions): GlobalOptions = {
      if (workdir.isDefined) {
        c.copy(workdirPath = workdir.get.toString)
      } else if (verbose.isDefined) {
        c.copy(verbose = verbose.get)
      } else if (keepTmpDirs.isDefined) {
        c.copy(keepTmpDirs = keepTmpDirs.get)
      } else {
        sys.exit(1)
      }
    }

    val commands: List[(String, String, (Array[String], String) => Unit)] = List(
      ("init", "Initialize the configuration for denali", (localArgs: Array[String], helpStr: String) => {
        val parser = new scopt.OptionParser[InitOptions]("denali") {
          head(shortDescription)
          note(helpStr)

          addGlobalOptions(this, "init",
            (workdir: Option[File], verbose: Option[Boolean], keepTmpDirs: Option[Boolean], c: InitOptions) => {
              if (workdir.isDefined) {
                c.copy(globalOptions = c.globalOptions.copy(workdirPath = workdir.get.toString))
              } else if (verbose.isDefined) {
                c.copy(globalOptions = c.globalOptions.copy(verbose = verbose.get))
              } else if (keepTmpDirs.isDefined) {
                c.copy(globalOptions = c.globalOptions.copy(keepTmpDirs = keepTmpDirs.get))
              } else {
                sys.exit(1)
              }
            })
        }
        parser.parse(localArgs, InitOptions(GlobalOptions())) match {
          case Some(c) =>
            Initialize.run(args, c)
          case None =>
            // arguments are bad, error message will have been displayed
            sys.exit(1)
        }
      }),

      ("run", "A full run of denali",
        (localArgs: Array[String], helpStr: String) => {
          val parser = new scopt.OptionParser[GlobalOptions]("denali") {
            head(shortDescription)
            note(helpStr)

            addGlobalOptions(this, "run", normalUpdateGlobal)
          }
          parser.parse(localArgs, GlobalOptions()) match {
            case Some(c) =>
              Driver(c).run(args)
            case None =>
              // arguments are bad, error message will have been displayed
              sys.exit(1)
          }
        }),

      ("stats", "Gather statistics for the working directory (which may still be running)",
        (localArgs: Array[String], helpStr: String) => {
          val parser = new scopt.OptionParser[GlobalOptions]("denali") {
            head(shortDescription)
            note(helpStr)

            addGlobalOptions(this, "stats", normalUpdateGlobal)
          }
          parser.parse(localArgs, GlobalOptions()) match {
            case Some(c) =>
              Statistics.run(c)
            case None =>
              // arguments are bad, error message will have been displayed
              sys.exit(1)
          }
        }),

      ("cleanup", "Clean up the working directory after a crash (removing stray lock files, etc.)",
        (localArgs: Array[String], helpStr: String) => {
          val parser = new scopt.OptionParser[GlobalOptions]("denali") {
            head(shortDescription)
            note(helpStr)

            addGlobalOptions(this, "cleanup", normalUpdateGlobal)
          }
          parser.parse(localArgs, GlobalOptions()) match {
            case Some(c) =>
              State(c).appendLog(LogEntryPoint(args))
              State(c).cleanup()
            case None =>
              // arguments are bad, error message will have been displayed
              sys.exit(1)
          }
        }),

      ("shutdown", "Indicate that all threads should shut down and safely exit.  May take some time.",
        (localArgs: Array[String], helpStr: String) => {
          val parser = new scopt.OptionParser[GlobalOptions]("denali") {
            head(shortDescription)
            note(helpStr)

            addGlobalOptions(this, "shutdown", normalUpdateGlobal)
          }
          parser.parse(localArgs, GlobalOptions()) match {
            case Some(c) =>
              State(c).appendLog(LogEntryPoint(args))
              State(c) signalShutdown()
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

          addGlobalOptions(this, "init", normalUpdateGlobal)
          opt[Instruction]("instr") valueName ("<opcode>") action {
            (x, c: GlobalOptions) => {
              instr = Some(x)
              c
            }
          } text (s"The instruction that should be processed next.")
        }
        parser.parse(localArgs, GlobalOptions()) match {
          case Some(c) =>
            State(c).appendLog(LogEntryPoint(args))
            val driver = Driver(c)
            driver.selectNextTask(instr) match {
              case None =>
                IO.info("No task available")
              case Some(task) =>
                IO.info(s"Selected task '$task'")
                val res = driver.runTaskAsync(task)
                driver.finishTask(task, res)
                driver.endAsync()
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
case class GlobalOptions(workdirPath: String = s"${System.getProperty("user.home")}/dev/output-denali",
                         verbose: Boolean = false, keepTmpDirs: Boolean = false) {
  val workdir = new File(workdirPath)
}

case class InitOptions(globalOptions: GlobalOptions)
