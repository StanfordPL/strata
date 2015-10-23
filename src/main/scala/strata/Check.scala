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

    val graph: Graph[Instruction, DiEdge] = dependencyGraph

    for (node <- graph.topologicalSort) {
      println(node)
    }

  }

  /** Compute the dependency graph of all the circuits. */
  private def dependencyGraph: Graph[Instruction, DiEdge] = {
    val graph = Graph[Instruction, DiEdge]()

    // loop over all circuits
    for (circuitFile <- options.circuitPath.listFiles) {
      val program = Program.fromFile(circuitFile)
      val circuit = Instruction(circuitFile.getName.substring(0, circuitFile.getName.length - 2))

      for (instruction <- program.instructions) {
        graph += (circuit ~> instruction)
      }
    }

    graph
  }
}
