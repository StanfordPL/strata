package denali.data

import denali.GlobalOptions

/**
 * A x86_64 instruction.
 */
class Instruction(val opcode: String, cmdOptions: GlobalOptions) {
  override def toString = opcode
}

object Instruction {
  def unapply(instr: Instruction): Option[String] = Some(instr.opcode)
}
