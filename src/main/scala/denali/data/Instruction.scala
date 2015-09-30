package denali.data

/**
 * A x86_64 instruction.
 */
case class Instruction(opcode: String) {
  override def toString = opcode
}
