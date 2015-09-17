package denali

import scala.io.Source

/**
 * Code to interact with the configuration of a denali run.
 */
class Config(cmdOptions: CmdOptions) {
  def getGoal: Seq[Instruction] = {
    val res = for (goal <- Source.fromFile(s"${cmdOptions.workdir}/config/goal.txt").getLines()) yield {
      new Instruction(goal.stripLineEnd, cmdOptions)
    }
    res.toSeq
  }
}

object Config {
  def apply(cmdOptions: CmdOptions) = new Config(cmdOptions)
}
