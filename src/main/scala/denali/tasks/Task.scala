package denali.tasks

import denali.data.Instruction

/**
 * A trait for steps the driver can take
 */
sealed trait Task

case class InitialSearchStep(instruction: Instruction) extends Task