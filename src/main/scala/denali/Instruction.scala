package denali

/**
 * A x86_64 instruction.
 */
class Instruction(val opcode: String, cmdOptions: CmdOptions) {
  override def toString = opcode
}

object Instruction {
  def unapply(instr: Instruction): Option[String] = Some(instr.opcode)
}
