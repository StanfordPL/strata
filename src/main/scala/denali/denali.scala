package denali

import java.io.File

/**
 * Main entry point.
 */
object Denali {
  def main(args: Array[String]) {
    val parser = new scopt.OptionParser[CmdOptions]("denali") {
      head("Automatic inference of a formal specification of the x86_64 instruction set")
      help("help") text "Usage information"
      version("version") text "Version"

      opt[File]('w', "workdir") valueName("<dir>") action {
        (x, c) => c.copy(workdir = x)
      } text(s"The directory where outputs and intermediate progress are stored. Default: ${CmdOptions().workdir}")

      cmd("init") action {
        (_, c) => c.copy(cmd = "init")
      }
      cmd("step") action {
        (_, c) => c.copy(cmd = "step")
      }
      checkConfig {
        case c: CmdOptions if c.cmd == "" => failure("Command required.")
        case _ => success
      }
    }

    // parser.parse returns Option[C]
    parser.parse(args, CmdOptions()) match {
      case Some(c) if c.cmd == "init" =>
        Initialize.run(c)
      case Some(_) =>
        println("ERROR: unexpected command")
        sys.exit(1)
      case None =>
      // arguments are bad, error message will have been displayed
    }
  }
}

/**
 * Command line argument class.
 *
 * @param cmd The command to run
 */
case class CmdOptions(cmd: String = "", workdir: File = new File(s"${System.getProperty("user.home")}/dev/denali-output"))
