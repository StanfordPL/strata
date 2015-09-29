package denali.data

import denali.GlobalOptions

/**
 * A x86_64 instruction.
 */
class Instruction(val opcode: String, cmdOptions: GlobalOptions) {
  override def toString = opcode

  override def equals(other: Any): Boolean = {
    if (!other.isInstanceOf[Instruction]) return false
    other.asInstanceOf[Instruction].opcode == opcode
  }
}

object Instruction {
  def unapply(instr: Instruction): Option[String] = Some(instr.opcode)
}
