package strata.data

import java.io.File

import strata.util.IO

/** An abstract program; a list of instructions. */
case class Program(instructions: Seq[Instruction])
object Program {
  def fromFile(f: File): Program = {
    val Pattern = "  .*#.*OPC=([^ ]*) *".r
    val instructions = (for (line <- IO.readFile(f).split("\n")) yield {
      line match {
        case Pattern(opcode) =>
          if (opcode != "retq" && opcode != "<label>") {
            Some(Instruction(opcode))
          } else {
            None
          }
        case _ => None
      }
    }).flatten
    Program(instructions)
  }
}
