

/**
 * Main entry point.
 */
object Denali {
  def main(args: Array[String]) {
    val parser = new scopt.OptionParser[Config]("denali") {
      head("Automatic inference of a formal specification of the x86_64 instruction set")
      help("help") text "Usage information"
      version("version") text "Version"

      note("")
      cmd("init") action {
        (_, c) => c.copy(cmd = "init")
      }
      cmd("step") action {
        (_, c) => c.copy(cmd = "step")
      }
      checkConfig {
        case Config("") => failure("Command required.")
        case _ => success
      }
    }

    // parser.parse returns Option[C]
    parser.parse(args, Config()) match {
      case Some(c@Config("init")) =>
        Initialize.run()
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
case class Config(cmd: String = "")
