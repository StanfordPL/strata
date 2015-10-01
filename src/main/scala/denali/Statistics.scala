package denali

import denali.data.{InstructionFile, Instruction, State}
import denali.util.IO

/**
 * A class to collect various statistics of the current run.
 */
object Statistics {
  def print(globalOptions: GlobalOptions): Unit = {
    val state = State(globalOptions)

    state.lockedInformation(() => {
      val log = IO.readFile(state.getLogFile).split("\n")

      println("Denali statistics")
      println("")
      if (log.nonEmpty) {
        println(s"First log line: ${log.head}")
        println(s"Last log line: ${log.last}")
      }

      println("")
      val nBase = state.getInstructionFile(InstructionFile.Base, includeWorklist = true).length
      println(s"Initial base instructions: $nBase")
      println(s"Overall goal instructions: ${state.getInstructionFile(InstructionFile.InitialGoal, includeWorklist = true).length}")
      val nSuccess = state.getInstructionFile(InstructionFile.Success, includeWorklist = true).length
      println(s"Successful searches:       ${nSuccess - nBase}")
    })
  }
}
