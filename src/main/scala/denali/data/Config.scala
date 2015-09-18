package denali.data

import denali.GlobalOptions

import scala.io.Source

/**
 * Code to interact with the configuration of a denali run.
 */
class Config(cmdOptions: GlobalOptions) {
  def getGoal: Seq[Instruction] = {
    val file = Source.fromFile(s"${cmdOptions.workdir}/config/goal.txt")
    val res = for (goal <- file.getLines()) yield {
      new Instruction(goal.stripLineEnd, cmdOptions)
    }
    file.close()
    res.toSeq
  }
}

object Config {
  def apply(cmdOptions: GlobalOptions) = new Config(cmdOptions)
}
