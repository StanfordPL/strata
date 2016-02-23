package strata

import java.io.{FileWriter, File}
import java.util.Date

import strata.data._
import strata.tasks.InitialSearch
import strata.util.{Distribution, IO}

import scala.io.Source
import scala.util.Random
import scala.util.control.Breaks

/**
 * Main entry point.
 */
object Strata {
  def main(args: Array[String]) {

    // fix randomness for now
    //Random.setSeed(0)

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
      ("init", "Initialize the configuration for strata", (localArgs: Array[String], helpStr: String) => {
        val parser = new scopt.OptionParser[InitOptions]("strata") {
          head(shortDescription)
          note(helpStr)

          addGlobalOptions(this, "init",
            (workdir: Option[File], verbose: Option[Boolean], keepTmpDirs: Option[Boolean], c: InitOptions) => {
              c.copy(globalOptions = normalUpdateGlobal(workdir, verbose, keepTmpDirs, c.globalOptions))
            })
          opt[Unit]('i', "imm_instructions") action {
            (x, c) => c.copy(imm_instructions = true)
          }
          opt[Int]("imm_block") action {
            (x, c) => c.copy(imm_block = x)
          }
          opt[Unit]("no_stratification") action {
            (x, c) => c.copy(no_stratification = true)
          }
        }
        parser.parse(localArgs, InitOptions(GlobalOptions(), false)) match {
          case Some(c) =>
            Initialize.run(args, c)
          case None =>
            // arguments are bad, error message will have been displayed
            sys.exit(1)
        }
      }),

      ("run", "A full run of strata",
        (localArgs: Array[String], helpStr: String) => {
          val parser = new scopt.OptionParser[InitOptions]("strata") {
            head(shortDescription)
            note(helpStr)

            addGlobalOptions(this, "run",
              (workdir: Option[File], verbose: Option[Boolean], keepTmpDirs: Option[Boolean], c: InitOptions) => {
                c.copy(globalOptions = normalUpdateGlobal(workdir, verbose, keepTmpDirs, c.globalOptions))
              })
            opt[Unit]('i', "imm_instructions") action {
              (x, c) => c.copy(imm_instructions = true)
            }
            opt[Int]("imm_block") action {
              (x, c) => c.copy(imm_block = x)
            }
            opt[Unit]("no_stratification") action {
              (x, c) => c.copy(no_stratification = true)
            }
          }
          parser.parse(localArgs, InitOptions(GlobalOptions())) match {
            case Some(c) =>
              Driver(c).run(args)
            case None =>
              // arguments are bad, error message will have been displayed
              sys.exit(1)
          }
        }),

      ("continue", "Continue an already running run of strata",
        (localArgs: Array[String], helpStr: String) => {
          val parser = new scopt.OptionParser[InitOptions]("strata") {
            head(shortDescription)
            note(helpStr)

            addGlobalOptions(this, "continue",
              (workdir: Option[File], verbose: Option[Boolean], keepTmpDirs: Option[Boolean], c: InitOptions) => {
                c.copy(globalOptions = normalUpdateGlobal(workdir, verbose, keepTmpDirs, c.globalOptions))
              })
            opt[Unit]('i', "imm_instructions") action {
              (x, c) => c.copy(imm_instructions = true)
            }
          }
          parser.parse(localArgs, InitOptions(GlobalOptions())) match {
            case Some(c) =>
              Driver(c).run(args, continue=true)
            case None =>
              // arguments are bad, error message will have been displayed
              sys.exit(1)
          }
        }),

      ("status", "Gather statistics for the working directory (which may still be running)",
        (localArgs: Array[String], helpStr: String) => {
          val parser = new scopt.OptionParser[GlobalOptions]("strata") {
            head(shortDescription)
            note(helpStr)

            addGlobalOptions(this, "status", normalUpdateGlobal)
          }
          parser.parse(localArgs, GlobalOptions()) match {
            case Some(c) =>
              Statistics.run(c, singleRun = true)
            case None =>
              // arguments are bad, error message will have been displayed
              sys.exit(1)
          }
        }),

      ("status-continue", "Gather statistics for the working directory (which may still be running) continuously",
        (localArgs: Array[String], helpStr: String) => {
          val parser = new scopt.OptionParser[GlobalOptions]("strata") {
            head(shortDescription)
            note(helpStr)

            addGlobalOptions(this, "status-continue", normalUpdateGlobal)
          }
          parser.parse(localArgs, GlobalOptions()) match {
            case Some(c) =>
              Statistics.run(c, singleRun = false)
            case None =>
              // arguments are bad, error message will have been displayed
              sys.exit(1)
          }
        }),

      ("tmp", "Various ad-hoc things",
        (localArgs: Array[String], helpStr: String) => {
          val parser = new scopt.OptionParser[GlobalOptions]("strata") {
            head(shortDescription)
            note(helpStr)

            addGlobalOptions(this, "tmp", normalUpdateGlobal)
          }
          parser.parse(localArgs, GlobalOptions()) match {
            case Some(c) =>
              Statistics.tmp(c)
            case None =>
              // arguments are bad, error message will have been displayed
              sys.exit(1)
          }
        }),

      ("evaluate", "Evaluate the data from an experiment (to later produce graphs, etc.)",
        (localArgs: Array[String], helpStr: String) => {
          val parser = new scopt.OptionParser[EvaluateOptions]("strata") {
            head(shortDescription)
            note(helpStr)
            help("help") text s"Usage information for the evaluate command"
            opt[File]("dataPath") valueName ("<dir>") action {
              (x, c) => c.copy(dataPath = x)
            } text (s"The directory where the output of the experiment is stored. Default: ${EvaluateOptions().dataPath}")
            opt[Unit]('v', "verbose") action {
              (x, c) => c.copy(verbose = true)
            } text (s"Verbose output.  Default: ${EvaluateOptions().verbose}")
          }
          parser.parse(localArgs, EvaluateOptions()) match {
            case Some(c) =>
              Statistics.collectData(c)
            case None =>
              // arguments are bad, error message will have been displayed
              sys.exit(1)
          }
        }),

      ("analysis", "Analyise use of base set instruction usage",
        (localArgs: Array[String], helpStr: String) => {
          val parser = new scopt.OptionParser[EvaluateOptions]("strata") {
            head(shortDescription)
            note(helpStr)
            help("help") text s"Usage information for the analysis command"
            opt[File]("dataPath") valueName ("<dir>") action {
              (x, c) => c.copy(dataPath = x)
            } text (s"The directory where the output of the experiment is stored. Default: ${EvaluateOptions().dataPath}")
            opt[Unit]('v', "verbose") action {
              (x, c) => c.copy(verbose = true)
            } text (s"Verbose output.  Default: ${EvaluateOptions().verbose}")
          }
          parser.parse(localArgs, EvaluateOptions()) match {
            case Some(c) =>
              Statistics.analysis(c)
            case None =>
              // arguments are bad, error message will have been displayed
              sys.exit(1)
          }
        }),

      ("cleanup", "Clean up the working directory after a crash (removing stray lock files, etc.)",
        (localArgs: Array[String], helpStr: String) => {
          val parser = new scopt.OptionParser[GlobalOptions]("strata") {
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
          val parser = new scopt.OptionParser[GlobalOptions]("strata") {
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

      ("check", "Check the circuits found by strata against the circuits used in STOKE.",
        (localArgs: Array[String], helpStr: String) => {
          val parser = new scopt.OptionParser[EvaluateOptions]("strata") {
            head(shortDescription)
            note(helpStr)
            help("help") text s"Usage information for the check command"
            opt[File]("dataPath") valueName ("<dir>") action {
              (x, c) => c.copy(dataPath = x)
            } text (s"The directory where the output of the experiment is stored. Default: ${EvaluateOptions().dataPath}")
            opt[Unit]('v', "verbose") action {
              (x, c) => c.copy(verbose = true)
            } text (s"Verbose output.  Default: ${EvaluateOptions().verbose}")
          }
          parser.parse(localArgs, EvaluateOptions()) match {
            case Some(c) =>
              Check(c).run()
            case None =>
              // arguments are bad, error message will have been displayed
              sys.exit(1)
          }
        }),

      ("step", "Take one more step towards finding the right specification", (localArgs: Array[String], helpStr: String) => {
        var instr: Option[Instruction] = None
        var continue: Boolean = false
        val parser = new scopt.OptionParser[GlobalOptions]("strata") {
          head(shortDescription)
          note(helpStr)

          addGlobalOptions(this, "step", normalUpdateGlobal)
          opt[Instruction]("instr") valueName ("<opcode>") action {
            (x, c: GlobalOptions) => {
              instr = Some(x)
              c
            }
          } text (s"The instruction that should be processed next.")
          opt[Unit]('c', "continue") valueName ("<opcode>") action {
            (x, c: GlobalOptions) => {
              continue = true
              c
            }
          } text (s"The instruction that should be processed next.")
        }
        parser.parse(localArgs, GlobalOptions()) match {
          case Some(c) =>
            State(c).appendLog(LogEntryPoint(args))
            val driver = Driver(InitOptions(c))
            Breaks.breakable {
              while (true) {
                driver.selectNextTask(instr) match {
                  case None =>
                    IO.info("No task available")
                    Breaks.break()
                  case Some(task) =>
                    IO.info(s"Selected task '$task'")
                    val res = driver.runTaskAsync(task)
                    driver.finishTask(task, res)
                    driver.endAsync()
                    if (!continue) {
                      Breaks.break()
                    }
                }
              }
            }
          case None =>
            // arguments are bad, error message will have been displayed
            sys.exit(1)
        }
      })
    )

    if (args.length > 0) {
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
    } else {
      println(s"No command given.\n")
      showHelp(shortDescription, commands)
      sys.exit(1)
    }
  }

  def showHelp(shortDescription: String, commands: List[(String, String, (Array[String], String) => Unit)]): Unit = {
    println("usage: strata [-h/--help] <command> [options]")
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
    println("Use 'strata <command> --help' to see the available options for a given command.")
  }
}

/**
 * Command line argument class.
 */
case class GlobalOptions(workdirPath: String = s"${System.getProperty("user.home")}/dev/output-strata",
                         verbose: Boolean = false, keepTmpDirs: Boolean = false) {
  val workdir = new File(workdirPath).getAbsoluteFile
}

case class InitOptions(globalOptions: GlobalOptions, imm_instructions: Boolean = false, imm_block: Int = 0, no_stratification: Boolean = false)

case class EvaluateOptions(dataPath: File = new File(s"../strata-data"), verbose: Boolean = false) {
  def circuitPath = new File("/home/sheule/dev/circuits")//new File(s"$dataPath/circuits")
}
