package denali.tasks

import denali.GlobalOptions
import denali.data.{ThreadContext, Instruction}

/**
 * A trait for steps the driver can take
 */
sealed trait Task {
  def globalOptions: GlobalOptions

  def instruction: Instruction

  var runnerContext: ThreadContext = null
}

case class InitialSearchTask(globalOptions: GlobalOptions,
                             instruction: Instruction,
                             budget: Long,
                             pseudoTime: Int) extends Task {
  override def toString = {
    s"initial search for $instruction with budget=$budget"
  }
}

case class SecondarySearchTask(globalOptions: GlobalOptions,
                               instruction: Instruction,
                               budget: Long,
                               pseudoTime: Int) extends Task {
  override def toString = {
    s"secondary search for $instruction with budget=$budget"
  }
}
