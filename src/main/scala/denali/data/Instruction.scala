package denali.data

import denali.Denali._

import scala.collection.mutable.ListBuffer

/**
 * A x86_64 instruction.
 */
case class Instruction(opcode: String) {
  // test if opcode exists
  if (Instruction.all.isEmpty) {
    val stream = getClass.getResourceAsStream("/all.instrs")
    val res = ListBuffer[String]()
    for (line <- scala.io.Source.fromInputStream( stream ).getLines()) {
      res.append(line.stripLineEnd)
    }
    Instruction.all = res.toList
  }
  if (!Instruction.all.contains(opcode)) {
    throw new IllegalArgumentException(s"Opcode '$opcode' does not exist.")
  }

  override def toString = opcode
}

object Instruction {
  private var all: List[String] = List()
}
