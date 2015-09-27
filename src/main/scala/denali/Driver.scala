package denali

/**
 * Driver for a full run of denali.  Takes care of deciding what to run next.
 */
class Driver(val globalOptions: GlobalOptions) {

  def run(args: Array[String]): Unit = {
    // initialize
    Initialize.run(args, InitOptions(globalOptions))

    // main loop
    while (true) {
      // select a next step

      // execute step

    }
  }
}

/**
 * Companion object
 */
object Driver {
  def apply(globalOptions: GlobalOptions) = new Driver(globalOptions)
}