package strata.data

import strata.Strata._

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

  val realOpcode = if ("_[0-9]+$".r.findFirstIn(opcode).isDefined) {
    opcode.substring(0, opcode.lastIndexOf("_"))
  } else {
    opcode
  }

  if (!Instruction.all.contains(realOpcode)) {
    throw new IllegalArgumentException(s"Opcode '$realOpcode' does not exist.")
  }

  override def toString = opcode
}

object Instruction {
  private var all: List[String] = List()
}
