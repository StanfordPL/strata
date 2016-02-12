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
case class Check(options: EvaluateOptions) {

  implicit def orderingForPair1: Ordering[(Int, Instruction)] = Ordering.by(e => e._1)

  implicit def orderingForPair2: Ordering[(Instruction, Int)] = Ordering.by(e => e._2)

  val stokeIsWrong = Vector(
    // wrong AVX circuit: upper bits should be taken from source operand, not be left unmodified
    "vaddsd_xmm_xmm_xmm",
    "vsubsd_xmm_xmm_xmm",
    "vdivsd_xmm_xmm_xmm",
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
    "vsqrtsd_xmm_xmm_xmm", // 16

    // upper bits should be 0, but are kept unmodified
    "cvtpd2ps_xmm_xmm",
    "vcvtpd2ps_xmm_xmm",
    "cvttpd2dq_xmm_xmm",
    "vcvttpd2dq_xmm_xmm",
    "cvtpd2dq_xmm_xmm", // 5

    // should do add in upper bits and sub in lower bits, but reverses the two
    "addsubps_xmm_xmm",
    "vaddsubps_xmm_xmm_xmm",
    "vaddsubpd_xmm_xmm_xmm",
    "addsubpd_xmm_xmm",
    "vaddsubpd_ymm_ymm_ymm" // 5
  )

  val missingLemma = Vector(
    "vfnmsub132ss_xmm_xmm_xmm"
  )

  /** Run the check. */
  def run(): Unit = {

    val circuitPath = options.circuitPath
    val (strataInstrs, graph) = dependencyGraph(circuitPath)
    val baseSet = State(GlobalOptions(s"${options.dataPath}/data-regs")).getInstructionFile(InstructionFile.Base)

    //    val root = DotRootGraph(
    //      directed = true,
    //      id = Some("strata dependencies"))
    //    println(graph.toDot(root, x => Some((root, DotEdgeStmt(x.edge.source.toString, x.edge.target.toString)))))
    //    return

    // instruction stats
    val stats = Statistics.readInstructionStats
    def usedFor(x: Instruction) = {
      stats(x).used_for
    }

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
    println(difficultyDist.info("strata (for register-only variants)"))

    val debug = options.verbose

    var correct = 0
    var incorrect = 0
    var stoke_unsupported = 0
    var timeout = 0
    var stoke_wrong = 0
    var missing_lemma = 0
    var total = -1
    var usesWrongCircuit = 0
    val dontCheckWrong = false
    val incorrectInstrs = collection.mutable.Set.empty[Instruction]

    println("Analyzing correctness formulas (comparing with hand-written formulas where available).")
    println("There are no hand-written formulas available for the imm8 instructions.")
    println("")

    for (instruction <- graph.topologicalSort if strataInstrs.contains(instruction)) {
      if (graph.get(instruction).diPredecessors.size >= 0) {
        val cmd = Vector("timeout", "15s",
          s"${IO.getProjectBase}/stoke/bin/specgen", "compare",
          "--circuit_dir", circuitPath,
          //          "--no_simplify",
          //          "--solver", "cvc4",
          "--opcode", instruction)
        val (out, status) = IO.runQuiet(cmd)
        val usedNTimes = usedFor(instruction) + 1
        total += usedNTimes
        val program = Check.getProgram(circuitPath, instruction)

        // check if this uses an instruction that we already know to be wrong
        if (program.instructions.toSet.intersect(incorrectInstrs).nonEmpty && dontCheckWrong) {
          usesWrongCircuit += usedNTimes
          incorrectInstrs += instruction
        } else if (stokeIsWrong.contains(instruction.opcode)) {
          stoke_wrong += usedNTimes

          if (debug) {
            println()
            println("-------------------------------------")
            println()
            println(s"Hand-written formula for '$instruction' is wrong (it is used $usedNTimes times):")
            println()
            println(out.trim)
          }
        } else if (missingLemma.contains(instruction.opcode)) {
          missing_lemma += usedNTimes

          if (debug) {
            println()
            println("-------------------------------------")
            println()
            println(s"Formulas for '$instruction' are equivalent, but require a lemma (it is used $usedNTimes times):")
            println()
            println(out.trim)
          }
        } else if (status == 124) {
          println(s"$instruction: timeout")
          timeout += usedNTimes
        } else if (status == 2) {
          // not supported by STOKE
          stoke_unsupported += usedNTimes
        } else if (status == 4) {
          // circuits are not proven equivalent
          incorrect += usedNTimes

//          if (debug) {
            println()
            println("-------------------------------------")
            println()
            println(s"Formulas for '$instruction' are not equivalent (it is used $usedNTimes times):")
            println()
            println("Program:")
            println("  " + program.toString.replace("\n", "\n  "))
            println()
            println(out.trim)
//          } else {
//            println(s"$instruction: not equivalent")
//          }
          incorrectInstrs += instruction
        } else if (status == 0) {
          // correct :)
          correct += usedNTimes
        } else {
          println(s"Unexpected error: $status")
          println(out)
          assert(false)
        }
      }
    }

    println()
    //println(f"Total:                    $total")
    println(f"hand-written == strata:   $correct")
    println(f"hand-written is wrong:    $stoke_wrong")
    println(f"hand-written != strata:   $incorrect")
    println(f"missing lemma:            $missing_lemma")
    println(f"not checked:              $usesWrongCircuit (because it relies on previously reported wrong formulas)")
    println(f"Timeout:                  $timeout")
    println(f"Unsupported by STOKE:     $stoke_unsupported")

    println()
    val handwrittenFormulaAvailable = correct + stoke_wrong + incorrect + missing_lemma + usesWrongCircuit + timeout
    println(f"We can formally compare to handwritten formulas for ${handwrittenFormulaAvailable} instruction variants")
    println()
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
