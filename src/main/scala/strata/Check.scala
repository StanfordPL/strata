package strata

import java.io.File

import strata.data.{Program, Instruction}
import strata.util.IO

import scalax.collection.GraphEdge.DiEdge
import scalax.collection.mutable.Graph
import scalax.collection.GraphPredef._

/**
 * Check strata circuits against hand-written circuits in STOKE.
 */
case class Check(options: CheckOptions) {

  /** Run the check. */
  def run(): Unit = {

    val (strataInstrs, graph) = dependencyGraph

    val debug = false

    var correct = 0
    var incorrect = 0
    var stoke_unsupported = 0
    var timeout = 0
    for (instruction <- graph.topologicalSort) {
      val node = graph.get(instruction)
      if (node.diPredecessors.size >= 0) {
        val cmd = Vector("timeout", "15s",
          s"${IO.getProjectBase}/stoke/bin/specgen", "compare",
          "--circuit_dir", options.circuitPath,
          "--opcode", instruction)
        val (out, status) = IO.runQuiet(cmd)

        // only a few good outcomes
        if (status == 124) {
          println(s"$instruction: timeout")
          timeout += 1
        } else if (status == 2) {
          // not supported by STOKE
          stoke_unsupported += 1
        } else if (status == 4) {
          // circuits are not proven equivalent
          incorrect += 1

          if (debug) {
            println()
            println("-------------------------------------")
            println()
            println(s"Opcode '$instruction' not equivalent:")
            println()
            println("Program:")
            println("  " + getProgram(instruction).toString.replace("\n", "\n  "))
            println()
            println(out.trim)
          } else {
            println(s"$instruction: not equivalent")
          }
        } else if (status == 0) {
          // correct :)
          correct += 1
        } else {
          println(s"Unexpected error: $status")
          println(out)
          assert(false)
        }
      }
    }

    println()
    println(s"Total:                ${correct + incorrect + timeout + stoke_unsupported}")
    println(s"STOKE == strata:      $correct")
    println(s"STOKE != strata:      $incorrect")
    println(s"Timeout:              $timeout")
    println(s"Unsupported by STOKE: $stoke_unsupported")

  }

  /** Compute the dependency graph of all the circuits. */
  private def dependencyGraph: (Seq[Instruction], Graph[Instruction, DiEdge]) = {
    val graph = Graph[Instruction, DiEdge]()

    // get all instructions
    val instructions = for (circuitFile <- options.circuitPath.listFiles) yield {
      Instruction(circuitFile.getName.substring(0, circuitFile.getName.length - 2))
    }

    // loop over all circuits
    for (circuitFile <- options.circuitPath.listFiles) {
      val program = Program.fromFile(circuitFile)
      val circuit = Instruction(circuitFile.getName.substring(0, circuitFile.getName.length - 2))

      // add dependencies, but only on instructions that we learned
      for (instruction <- program.instructions if instructions.contains(instruction)) {
        graph += (instruction ~> circuit)
      }
    }

    (instructions, graph)
  }

  private def getProgram(instruction: Instruction): Program = {
    Program.fromFile(new File(s"${options.circuitPath}/$instruction.s"))
  }
}
