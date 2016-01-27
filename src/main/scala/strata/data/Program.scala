package strata.data

import java.io.File

import strata.util.IO

/** An abstract program; a list of instructions. */
case class Program(instructions: Seq[Instruction], src: String) {
  override def toString = {
    src
  }
}
object Program {
  def fromFile(f: File): Program = {
    val Pattern = "  (.*)#.*OPC=([^ ]*) *".r
    val Pattern2 = "callq .(.*)".r
    val instructions = (for (line <- IO.readFile(f).split("\n")) yield {
      line match {
        case Pattern(code, opcode) =>
          if (opcode != "retq" && opcode != "<label>") {
            if (opcode == "callq_label") {
              code match {
                case Pattern2(label) =>
                  Some(code, Instruction(opcode)(label))
                case _ =>
                  assert(false)
                  None
              }
            } else {
              Some((code, Instruction(opcode)))
            }
          } else {
            None
          }
        case _ => None
      }
    }).flatten
    Program(instructions.map(_._2), instructions.map(_._1.trim).mkString("\n"))
  }
}
