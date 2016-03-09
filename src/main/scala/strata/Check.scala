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
    "addsubpd_xmm_xmm" // 4
  )

  val missingLemma = Vector(
    "vfnmadd132ss_xmm_xmm_xmm",
    "vfmadd132sd_xmm_xmm_xmm"
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
      1 //stats(x).used_for
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
    var total = 0
    var usesWrongCircuit = 0
    val dontCheckWrong = false
    val incorrectInstrs = collection.mutable.Set.empty[Instruction]

    println("Analyzing correctness formulas (comparing with hand-written formulas where available).")
    println("There are no hand-written formulas available for the imm8 instructions.")
    println("")

    // imm8 instructions
    val (data, data2) = Statistics.readInstructionStatsBase
//    val imm8_instructions = data2.filter(x => x.stoke_support && x.strata_support).map(x => Instruction(x.instr))

    val imm8_instructions = for (circuitFile <- circuitPath.listFiles if Check.isImm8CicuitFile(circuitFile)) yield {
      Instruction(circuitFile.getName.substring(0, circuitFile.getName.length - 2))
    }

    println()
    println(f"Number of imm8 instructions: ${imm8_instructions.size.toDouble/256.0}%.2f or ${imm8_instructions.size}")

//    for (b <- baseSet) {
//      correct += usedFor(b) * 256
//      total += usedFor(b) * 256
//    }

    val unsupportedImm8 = data2.map(x => if (!x.stoke_support) x.used_for + 1 else 0).sum
//    total += unsupportedImm8
//    stoke_unsupported += unsupportedImm8

    val all = strataInstrs ++ imm8_instructions
    var all2: Seq[Instruction] = /*graph.topologicalSort ++ */imm8_instructions
    all2 = graph.topologicalSort
    for (instruction <- all2 if all.contains(instruction)) {
      val isImm8 = imm8_instructions.contains(instruction)
      if (isImm8 || graph.get(instruction).diPredecessors.size >= 0) {
        val cmd = Vector("timeout", "15s",
          s"${IO.getProjectBase}/stoke/bin/specgen", "compare",
          "--circuit_dir", circuitPath,
          //          "--no_simplify",
          //          "--solver", "cvc4",
          "--opcode", instruction)
        //println(IO.cmd2String(cmd))
        val (out, status) = IO.runQuiet(cmd)
        val usedNTimes = if (!isImm8) {
          (usedFor(instruction) + 1) * 256
        } else {
          usedFor(instruction) + 1
        }
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
            println(f"Hand-written formula for '$instruction' is wrong (it is used ${usedNTimes.toDouble/256.0}%.1f times):")
            println()
            println(out.trim)
          }
        } else if (missingLemma.contains(instruction.opcode)) {
          missing_lemma += usedNTimes

          if (debug) {
            println()
            println("-------------------------------------")
            println()
            println(f"Formulas for '$instruction' are equivalent, but require a lemma (it is used ${usedNTimes.toDouble/256.0}%.1f times):")
            println()
            println(out.trim)
          }
        } else if (status == 124) {
          println()
          println("-------------------------------------")
          println()
          println(f"Timed out for '$instruction', no equivalence information available.")
          timeout += usedNTimes
        } else if (status == 2) {
          // not supported by STOKE
          stoke_unsupported += usedNTimes
        } else if (status == 4) {
          // circuits are not proven equivalent
          incorrect += usedNTimes

          println()
          println("-------------------------------------")
          println()
          println(f"Formulas for '$instruction' are not equivalent (it is used ${usedNTimes.toDouble/256.0}%.1f times):")
          println()
          println("Program:")
          println("  " + program.toString.replace("\n", "\n  "))
          println()
          println(out.trim)
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
    println(f"Total:                    ${total.toDouble/256.0}%.2f")
    println(f"hand-written == strata:   ${correct.toDouble/256.0}%.2f")
    println(f"hand-written is wrong:    ${stoke_wrong.toDouble/256.0}%.2f")
    println(f"hand-written != strata:   ${incorrect.toDouble/256.0}%.2f")
    println(f"missing lemma:            ${missing_lemma.toDouble/256.0}%.2f")
    println(f"not checked:              ${usesWrongCircuit.toDouble/256.0}%.2f (because it relies on previously reported wrong formulas)")
    println(f"Timeout:                  ${timeout.toDouble/256.0}%.2f")
    println(f"Unsupported by STOKE:     ${stoke_unsupported.toDouble/256.0}%.2f")

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
