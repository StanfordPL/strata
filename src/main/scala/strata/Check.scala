package strata

import java.io.File

import com.github.tototoshi.csv.CSVWriter
import strata.data.{LogTaskEnd, Program, Instruction}
import strata.tasks.InitialSearchTimeout
import strata.util.{Distribution, IO}

import scala.collection.mutable
import scala.util.control.Breaks
import scalax.collection.GraphEdge.DiEdge
import scalax.collection.mutable.Graph
import scalax.collection.GraphPredef._
import scalax.collection.io.dot._
import scalax.collection.io.dot.implicits._

/**
 * Check strata circuits against hand-written circuits in STOKE.
 */
case class Check(options: CheckOptions) {

  implicit def orderingForPair1: Ordering[(Int, Instruction)] = Ordering.by(e => e._1)
  implicit def orderingForPair2: Ordering[(Instruction, Int)] = Ordering.by(e => e._2)

  def levelGraph(): Unit = {
    val (strataInstrs, graph) = dependencyGraph(options.circuitPath)
    val difficultyMap: Map[Instruction, (Int, Instruction)] = computeDifficultyMap(graph)
    val difficultyDist = difficultyMap.values.map(_._1.toLong).toSeq
    val writer = CSVWriter.open(new File("../data-strata/levels.csv"))
    for (level <- difficultyMap.values.map(_._1)) {
      writer.writeRow(Vector(level))
    }
    writer.close()
  }

  val stokeIsWrong = Vector(
    "vaddss_xmm_xmm_xmm",
    "vcvtss2sd_xmm_xmm_xmm",
    "vcvtsi2ssl_xmm_xmm_r32",
    "vcvtsi2sdl_xmm_xmm_r32",
    "vsqrtsd_xmm_xmm_xmm",
    "vaddsd_xmm_xmm_xmm",
    "vrcpss_xmm_xmm_xmm",
    "vcvtsd2ss_xmm_xmm_xmm",
    "vsubss_xmm_xmm_xmm",
    "vsubss_xmm_xmm_xmm",
    "vcvtsi2sdq_xmm_xmm_r64",
    "vdivss_xmm_xmm_xmm",
    "vsqrtss_xmm_xmm_xmm",
    "vrsqrtss_xmm_xmm_xmm",
    "vsubsd_xmm_xmm_xmm",
    "vcvtsi2ssq_xmm_xmm_r64",
    "vdivsd_xmm_xmm_xmm",
    "vmulsd_xmm_xmm_xmm",
    "vmulss_xmm_xmm_xmm",
    "vcvttpd2dq_xmm_xmm",

    "vcvtpd2ps_xmm_xmm"
  )

  val ignore = Vector(
    "cvtsi2ssl_xmm_r32",
    "cvtsi2sdl_xmm_r32",
    "vcvtdq2pd_xmm_xmm",
    "vcvtdq2pd_ymm_ymm",
    "cvtdq2pd_xmm_xmm"
  )
  // vcvtdq2pd_ymm_ymm, vminsd_xmm_xmm_xmm, vdivsd_xmm_xmm_xmm
  /** Run the check. */
  def run(): Unit = {

    val (strataInstrs, graph) = dependencyGraph(options.circuitPath)

    //    val root = DotRootGraph(
    //      directed = true,
    //      id = Some("strata dependencies"))
    //    println(graph.toDot(root, x => Some((root, DotEdgeStmt(x.edge.source.toString, x.edge.target.toString)))))
    //    return

    // how many instructions did we need to learn in sequence.
    val difficultyMap: Map[Instruction, (Int, Instruction)] = computeDifficultyMap(graph)
    val max = difficultyMap.values.max
    println(s"Maximum path length is ${max._1} (i.e. there is an instruction that required learning ${max._1 - 1} instructions first).")
    println("Path:")
    var cur = max._2
    Breaks.breakable {
      while (true) {
        println(cur)
        if (difficultyMap(cur)._1 == 0)
          Breaks.break()
        cur = difficultyMap(cur)._2
      }
    }
    println()
    val difficultyDist = Distribution(difficultyMap.values.map(_._1.toLong).toSeq)
    println(difficultyDist.info("path lengths for all instructions"))

    val debug = options.verbose

    var correct = 0
    var incorrect = 0
    var stoke_unsupported = 0
    var timeout = 0
    var stoke_wrong = 0
    var missing_lemma = 0
    var total = 0
    var usesWrongCircuit = 0
    val dontCheckWrong = false
    val incorrectInstrs = collection.mutable.Set.empty[Instruction]
    for (instruction <- graph.topologicalSort if strataInstrs.contains(instruction)) {
      val node = graph.get(instruction)
      if (node.diPredecessors.size >= 0) {
        val cmd = Vector("timeout", "15s",
          s"${IO.getProjectBase}/stoke/bin/specgen", "compare",
          "--circuit_dir", options.circuitPath,
          "--opcode", instruction)
        val (out, status) = IO.runQuiet(cmd)
        total += 1
        val program = getProgram(instruction)

        // check if this uses an instruction that we already know to be wrong
        if (program.instructions.toSet.intersect(incorrectInstrs).nonEmpty && dontCheckWrong) {
          usesWrongCircuit += 1
          incorrectInstrs += instruction
        } else if (stokeIsWrong.contains(instruction.opcode)) {
          stoke_wrong += 1
        } else if (ignore.contains(instruction.opcode)) {
          missing_lemma += 1
        } else if (status == 124) {
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
            println("  " + program.toString.replace("\n", "\n  "))
            println()
            println(out.trim)
          } else {
            println(s"$instruction: not equivalent")
          }
          incorrectInstrs += instruction
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
    println(s"Total:                $total")
    println(s"STOKE == strata:      $correct")
    println(s"STOKE is wrong:       $stoke_wrong")
    println(s"STOKE != strata:      $incorrect")
    println(s"missing lemma:        $missing_lemma")
    println(s"not checked:          $usesWrongCircuit (uses incorrect instruction)")
    println(s"Timeout:              $timeout")
    println(s"Unsupported by STOKE: $stoke_unsupported")

  }

  def computeDifficultyMap(graph: Graph[Instruction, DiEdge]): Map[Instruction, (Int, Instruction)] = {
    implicit def orderingForPair1: Ordering[(Int, Instruction)] = Ordering.by(e => e._1)
    val difficultyMap = collection.mutable.Map[Instruction, (Int, Instruction)]()
    for (instruction <- graph.topologicalSort) {
      val node = graph.get(instruction)
      if (node.inDegree == 0) {
        // instructions that we can learn directly get a score of 0
        difficultyMap(instruction) = (0, instruction)
      } else {
        // otherwise, take max over predecessors
        difficultyMap(instruction) = node.diPredecessors.map(x => (difficultyMap(x.value)._1 + 1, x.value)).max
      }
    }
    difficultyMap.toMap
  }

  /** Compute the dependency graph of all the circuits. */
  def dependencyGraph(circuitPath: File): (Seq[Instruction], Graph[Instruction, DiEdge]) = {
    val graph = Graph[Instruction, DiEdge]()

    // get all instructions
    val instructions = for (circuitFile <- circuitPath.listFiles) yield {
      Instruction(circuitFile.getName.substring(0, circuitFile.getName.length - 2))
    }

    // loop over all circuits
    for (circuitFile <- circuitPath.listFiles) {
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
