package strata

import java.io.File

import com.github.tototoshi.csv.CSVWriter
import strata.data._
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

  val stokeIsWrong = Vector(
    // wrong AVX circuit: upper bits should be taken from source operand, not be left unmodified
    "vaddsd_xmm_xmm_xmm",
    "vsubsd_xmm_xmm_xmm",
    "vdivsd_xmm_xmm_xmm",
    "vcvtsi2sdq_xmm_xmm_r64",
    "vcvtsi2ssq_xmm_xmm_r64",
    "vmulsd_xmm_xmm_xmm",
    "vrcpss_xmm_xmm_xmm",
    "vcvtsd2ss_xmm_xmm_xmm",
    "vsubss_xmm_xmm_xmm",
    "vcvtsi2ssl_xmm_xmm_r32",
    "vmulss_xmm_xmm_xmm",
    "vdivss_xmm_xmm_xmm",
    "vrsqrtss_xmm_xmm_xmm",
    "vsqrtss_xmm_xmm_xmm",
    "vcvtss2sd_xmm_xmm_xmm",
    "vcvtsi2sdl_xmm_xmm_r32",
    "vaddss_xmm_xmm_xmm",
    "vsqrtsd_xmm_xmm_xmm",

    // upper bits should be 0, but are kept unmodified
    "cvtpd2ps_xmm_xmm",
    "vcvtpd2ps_xmm_xmm",
    "cvttpd2dq_xmm_xmm",
    "vcvttpd2dq_xmm_xmm",
    "cvtpd2dq_xmm_xmm",

    // should convert 4 packed doubles, but only converts 2
    "vcvtpd2ps_xmm_ymm",
    "vcvttpd2dq_xmm_ymm",

    // should do add in upper bits and sub in lower bits, but reverses the two
    "addsubps_xmm_xmm",
    "vaddsubps_xmm_xmm_xmm",
    "vaddsubpd_xmm_xmm_xmm",
    "addsubpd_xmm_xmm",
    "vaddsubpd_ymm_ymm_ymm"
    //    "vaddss_xmm_xmm_xmm",
    //    "vcvtss2sd_xmm_xmm_xmm",
    //    "vcvtsi2ssl_xmm_xmm_r32",
    //    "vcvtsi2sdl_xmm_xmm_r32",
    //    "vsqrtsd_xmm_xmm_xmm",
    //    "vaddsd_xmm_xmm_xmm",
    //    "vrcpss_xmm_xmm_xmm",
    //    "vcvtsd2ss_xmm_xmm_xmm",
    //    "vsubss_xmm_xmm_xmm",
    //    "vsubss_xmm_xmm_xmm",
    //    "vcvtsi2sdq_xmm_xmm_r64",
    //    "vdivss_xmm_xmm_xmm",
    //    "vsqrtss_xmm_xmm_xmm",
    //    "vrsqrtss_xmm_xmm_xmm",
    //    "vsubsd_xmm_xmm_xmm",
    //    "vcvtsi2ssq_xmm_xmm_r64",
    //    "vdivsd_xmm_xmm_xmm",
    //    "vmulsd_xmm_xmm_xmm",
    //    "vmulss_xmm_xmm_xmm",
    //    "vcvttpd2dq_xmm_xmm",
    //    "vcvtpd2ps_xmm_xmm"
  )

  val missingLemma = Vector(
    // different convert (lemma)
//    "cvtsi2ssl_xmm_r32",
//    "vcvtdq2ps_xmm_xmm",
//    "cvtsi2sdl_xmm_r32",
//    "vcvtdq2pd_xmm_xmm",
//    "vcvtdq2pd_ymm_ymm",
//    "cvtdq2ps_xmm_xmm",
//    "vcvtdq2ps_ymm_ymm",
//    "cvtdq2pd_xmm_xmm",
//
//    // fused with 0 operand
//    "mulps_xmm_xmm",
//    "vmulps_xmm_xmm_xmm",
//    "vmulps_ymm_ymm_ymm",
//
//    // noop fused with two 0 operands
//    "addps_xmm_xmm",
//    "vaddps_xmm_xmm_xmm",
//
//    // add is commutative
//    "haddpd_xmm_xmm",
//    "vhaddpd_ymm_ymm_ymm",
//    "vhaddpd_xmm_xmm_xmm",
//    "vaddpd_ymm_ymm_ymm"
    //    "cvtsi2ssl_xmm_r32",
    //    "cvtsi2sdl_xmm_r32",
    //    "vcvtdq2pd_xmm_xmm",
    //    "vcvtdq2pd_ymm_ymm",
    //    "cvtdq2pd_xmm_xmm"
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
    val difficultyMap: Map[Instruction, Int] = computeDifficultyMap()
    val max = difficultyMap.values.max
    println(s"Maximum stratum is $max.")
//    println("Path:")
//    var cur = max._2
//    Breaks.breakable {
//      while (true) {
//        println(cur)
//        if (difficultyMap(cur)._1 == 0)
//          Breaks.break()
//        cur = difficultyMap(cur)._2
//      }
//    }
//    println()
    val difficultyDist = Distribution(difficultyMap.values.map(_.toLong).toSeq)
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
          //          "--no_simplify",
          //          "--solver", "cvc4",
          "--opcode", instruction)
        val (out, status) = IO.runQuiet(cmd)
        total += 1
        val program = Check.getProgram(options.circuitPath, instruction)

        // check if this uses an instruction that we already know to be wrong
        if (program.instructions.toSet.intersect(incorrectInstrs).nonEmpty && dontCheckWrong) {
          usesWrongCircuit += 1
          incorrectInstrs += instruction
        } else if (stokeIsWrong.contains(instruction.opcode)) {
          stoke_wrong += 1
        } else if (missingLemma.contains(instruction.opcode)) {
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

  def computeDifficultyMap(baseSet: Seq[Instruction] = Nil): Map[Instruction, Int] = {
    val (instrs, graph) = dependencyGraph(options.circuitPath)
    val difficultyMap = collection.mutable.Map[Instruction, Int]()
    for (instruction <- graph.topologicalSort) {
      val node = graph.get(instruction)
      if (node.inDegree == 0) {
        // instructions that we can learn directly get a score of 1
        difficultyMap(instruction) = 1
      } else {
        // otherwise, take max over predecessors
        difficultyMap(instruction) = node.diPredecessors.map(x => difficultyMap(x.value) + 1).max
      }
    }
    for (base <- baseSet) {
      difficultyMap(base) = 0
    }
    difficultyMap.toMap
  }

  /** Compute the dependency graph of all the circuits. */
  def dependencyGraph(circuitPath: File): (Seq[Instruction], Graph[Instruction, DiEdge]) = {
    val graph = Graph[Instruction, DiEdge]()

    // get all instructions
    val instructions = for (circuitFile <- circuitPath.listFiles if !Check.isImm8CicuitFile(circuitFile)) yield {
      Instruction(circuitFile.getName.substring(0, circuitFile.getName.length - 2))
    }
    // loop over all circuits
    for (circuitFile <- circuitPath.listFiles if !Check.isImm8CicuitFile(circuitFile)) {
      val program = Program.fromFile(circuitFile)
      val circuit = Instruction(circuitFile.getName.substring(0, circuitFile.getName.length - 2))

      // add this node
      graph += circuit

      // add dependencies, but only on instructions that we learned
      for (instruction <- program.instructions if instructions.contains(instruction)) {
        graph += (instruction ~> circuit)
      }
    }

    (instructions, graph)
  }
}

object Check {
  def getProgram(circuitPath: File, instruction: Instruction): Program = {
    Program.fromFile(new File(s"$circuitPath/$instruction.s"))
  }

  def isImm8CicuitFile(file: File) = {
    val name = file.getName.substring(0, file.getName.length - 2)
    name.contains("_imm8_")
  }
}
