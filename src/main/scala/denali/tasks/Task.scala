package denali.tasks

import denali.GlobalOptions
import denali.data.Instruction

/**
 * A trait for steps the driver can take
 */
sealed trait Task {
  def globalOptions: GlobalOptions
  def instruction: Instruction
}

case class InitialSearchTask(globalOptions: GlobalOptions,
                             instruction: Instruction,
                             budget: Int) extends Task {
  override def toString = {
    s"initial search for $instruction with budget=$budget"
  }
}
