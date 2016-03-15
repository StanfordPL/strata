package strata

import java.io.{FileInputStream, File}

import com.github.tototoshi.csv.CSVWriter
import org.joda.time.DateTime
import org.json4s.DefaultFormats
import org.json4s.native.JsonMethods._
import strata.data._
import strata.tasks._
import strata.util.ColoredOutput._
import strata.util._

import scala.collection.mutable.ListBuffer
import scala.concurrent.{ExecutionContext, Future}
import resource._

/**
 * A class to collect various statistics of the current run.
 */
object Statistics {

  def analysis(c: EvaluateOptions) = {
    //    val state = State(c)
    val baseSet = collection.mutable.Set[Instruction]() //state.getInstructionFile(InstructionFile.Base)
    val check = Check(c)
    val circuitPath = c.circuitPath
    val (instrs, graph) = check.dependencyGraph(circuitPath)
    val programs = instrs.map(x => Check.getProgram(circuitPath, x))
    val circuit2baseInstrUsed = collection.mutable.Map[Instruction, Set[Instruction]]()
    val circuit2fullInlinedSize = collection.mutable.Map[Instruction, Long]()
    for (instr <- graph.topologicalSort) {
      val set = collection.mutable.Set[Instruction]()
      var size: Long = 0
      for (impl <- Check.getProgram(circuitPath, instr).instructions) {
        if (impl.hasLabel) {
          size += 1
          //set += impl.label
        } else if (!circuit2baseInstrUsed.contains(impl)) {
          // must be base set
          baseSet += impl
          size += 1
          set += impl
        } else {
          size += circuit2fullInlinedSize(impl)
          set ++= circuit2baseInstrUsed(impl)
        }
      }
      circuit2fullInlinedSize(instr) = size
      circuit2baseInstrUsed(instr) = set.toSet
    }
    println(Stats.describe(circuit2fullInlinedSize.values.toList, "number of instructions"))
    val base2UsedBy = baseSet.toSeq.map(x => (x, instrs.filter(y => circuit2baseInstrUsed(y).contains(x)))).sortBy(x => x._2.length)
    for ((i, is) <- base2UsedBy) {
      println(s"${is.length}: $i")
      println("  " + is.mkString(", "))
    }
  }

  def toTime(x: DateTime): Long = {
    x.toDate.getTime
  }

  // take a time, and convert it into milliseconds since the start of the experiement, had it run the whole time
  def timeSinceStart(x: DateTime, offsets: Seq[(Long, Long)]): Long = {
    val time = toTime(x)
    var idx = 0
    while (idx < offsets.size && offsets(idx)._1 > time) {
      idx += 1
    }
    offsets(idx)._2 + (time - offsets(idx)._1)
  }

  // determine start times (taking into account breaks between entry points)
  def computeOffsets(messages: Seq[LogMessage]): (Long, Seq[(Long, Long)]) = {
    val sorted = messages.sortBy(x => toTime(x.time))
    // pairs of absolute time and time the experiement was running before
    val offsets = collection.mutable.ListBuffer[(Long, Long)]()

    var runSoFar = 0L
    var last = -1L
    for (m <- sorted) {
      m match {
        case LogEntryPoint(_, _, t, context) =>
          val host = context.hostname
          if (last != -1) {
            // add time for last interval
            runSoFar += (last - offsets.last._1)
          }
          // found a new start time, add it to the offsets
          offsets.append((toTime(t), runSoFar))
        case _ =>
      }
      last = toTime(m.time)
    }
    runSoFar += (toTime(sorted.last.time) - offsets.last._1)
    (runSoFar, offsets.toSeq)
  }

  val CLEAR_CONSOLE: String = "\u001b[H\u001b[2J"

  /** Some adhoc statistics. */
  def tmp(globalOptions: GlobalOptions): Unit = {
//    def computeProgress(): Unit = {
//      val state = State(globalOptions)
//      val messages = state.getLogMessages
//
//      val (runSoFar, offsets) = computeOffsets(messages)
//
//      val progressRows = messages.collect {
//        case LogTaskEnd(_, _, pt, time, ctx) if pt > 0 =>
//          assert(offsets.contains(ctx.hostname))
//          val tInMs = time.toDate.getTime - offsets(ctx.hostname)
//          (tInMs.toDouble / (1000d * 60d * 60d), pt)
//      }.sortBy(x => x._1)
//      val baseSetSize = progressRows.map(_._2).min
//      // optimize by dropping intermediate unchanged elements
//      for (writer <- managed(CSVWriter.open(new File("bin/progress.csv")))) {
//        var last = -1
//        for ((r, i) <- progressRows.zipWithIndex) {
//          if (r._2 != last || i == 0 || i == progressRows.size - 1) {
//            writer.writeRow(Vector(r._1, r._2 - baseSetSize))
//            last = r._2
//          }
//        }
//      }
//    }

//    def instructionsLearnedPreviously(): Unit = {
//      val state = State(GlobalOptions(workdirPath = "/home/sheule/dev/strata-data/data-regs"))
//      val messages = state.getLogMessages
//      val (runSoFar, offsets) = computeOffsets(messages)
//
//      val ms = messages.filter(p => {
//        val hours = (p.time.toDate.getTime - offsets(p.context.hostname)).toDouble / (1000d * 60d * 60d)
//        hours < 17
//      })
//
//      //      val extstats = getExtendedStats(ms)
//      //      def printBox(b: Box) = {
//      //        val (o, _) = printBoxesHorizontally(Vector(b), 45)
//      //        println(o)
//      //      }
//      //      printBox(extstats.otherInfoBox)
//      //      printBox(extstats.searchOverviewBox)
//      //      printBox(extstats.timingBox)
//      //      printBox(extstats.validatorInvocationsBox)
//      //      println()
//
//      val succ = ms.collect({
//        case LogEquivalenceClasses(instr, _, _, _) => instr
//      })
//      println(succ.map(i => i.realOpcode).sorted.mkString("\n"))
//    }

    def computeTimeSpentDoingX() = {
      val state = State(globalOptions)
      val messages = state.getLogMessages

      val taskResults = messages.collect({
        case LogTaskEnd(_, Some(res), _, _, _) => res
      })

      val categoryData = taskResults.map(x => {
        val cat = x.getClass.getName
        (cat, x.timing.total)
      }).groupBy(x => x._1)

      for ((cat, times) <- categoryData) {
        val t = times.map(x => x._2).sum
        println(s"$cat: ${IO.formatNanos(t)}")
      }
    }

    def investigateEqClasses() = {
      val AEstate = State(GlobalOptions("/home/sheule/dev/output-strata-fast-ae"))
      var AEmessages = AEstate.getLogMessages

      val AElogs = AEmessages.collect({
        case l@LogEquivalenceClasses(instr, eq, _, _) => l
      })
      val AEeqs = AElogs.map(x => x.eq)

      val state = State(GlobalOptions("/home/sheule/dev/output-strata"))
      var messages = state.getLogMessages

      val AElen = AEmessages.last.time.toDate.getTime - AEmessages.head.time.toDate.getTime
      val len = messages.last.time.toDate.getTime - messages.head.time.toDate.getTime
      val maxLen = Vector(AElen, len).min
      messages = messages.filter(p => p.time.toDate.getTime - messages.head.time.toDate.getTime < maxLen)
      AEmessages = AEmessages.filter(p => p.time.toDate.getTime - AEmessages.head.time.toDate.getTime < maxLen)

      val logs = messages.collect({
        case l@LogEquivalenceClasses(instr, eq, _, _) => l
      })
      val eqs = logs.map(x => x.eq)

      def test(a: Seq[LogMessage] => Unit) = {
        println("all equal")
        a(AEmessages)
        println("correct")
        a(messages)
        println("---------------")
      }

      println(Distribution(AEeqs.map(x => x.nClasses.toLong)).info("all equal"))
      println(Distribution(eqs.map(x => x.nClasses.toLong)).info("correct"))

      println(Distribution(AEeqs.map(x => x.nPrograms.toLong)).info("all equal"))
      println(Distribution(eqs.map(x => x.nPrograms.toLong)).info("correct"))

      test((msgs: Seq[LogMessage]) => {
        for ((cat, times) <- msgs.collect({
          case LogTaskEnd(_, Some(res), _, _, _) => res
        }).map(x => {
          val cat = x.getClass.getName
          (cat, x.timing.total)
        }).groupBy(x => x._1).toSeq.sortBy(x => x._1)) {
          val t = times.map(x => x._2).sum
          println(s"$cat: ${IO.formatNanos(t)}")
        }
      })

      test((msgs: Seq[LogMessage]) => {
        for ((cat, times) <- msgs.collect({
          case LogTaskEnd(_, Some(res), _, _, _) => res
        }).map(x => {
          val cat = x.getClass.getName
          (cat, x.timing.total)
        }).groupBy(x => x._1).toSeq.sortBy(x => x._1)) {
          val t = times.map(x => x._2).length
          println(s"$cat: ${(t)}")
        }
      })

      test((msgs: Seq[LogMessage]) => {
        println("Number of errors: " + msgs.count({
          case LogError(m, _, _) => true
          case _ => false
        }))
      })

      test((msgs: Seq[LogMessage]) => {
        println("Number of counterexamples: " + msgs.count({
          case LogVerifyResult(instr, true, StokeVerifyOutput(false, true, _, _), _, _, _, _) => true
          case _ => false
        }))
      })

      // compute progress for both
//      val (_, offsets) = computeOffsets(messages)
//      val progressRows = messages.collect {
//        case LogTaskEnd(_, _, pt, time, ctx) if pt > 0 =>
//          val tInMs = time.toDate.getTime - offsets(ctx.hostname)
//          (tInMs.toDouble / (1000d * 60d * 60d), pt, 1)
//      }
//      val baseSetSize = progressRows.map(_._2).min
//      val (aa, bb) = computeOffsets(AEmessages)
//      val AEprogressRows = AEmessages.collect {
//        case LogTaskEnd(_, _, pt, time, ctx) if pt > 0 =>
//          val tInMs = time.toDate.getTime - bb(ctx.hostname)
//          (tInMs.toDouble / (1000d * 60d * 60d), pt, 2)
//      }
//      val allRows = (progressRows ++ AEprogressRows).sortBy(x => x._1)
//      // optimize by dropping intermediate unchanged elements
//      for (writer <- managed(CSVWriter.open(new File("bin/progress.csv")))) {
//        var last = -1
//        var prev = (0, 0)
//        for ((r, i) <- allRows.zipWithIndex) {
//          if (r._2 != last || i == 0 || i == progressRows.size - 1) {
//            if (r._3 == 1) {
//              prev = (r._2 - baseSetSize, prev._2)
//            } else {
//              prev = (prev._1, r._2 - baseSetSize)
//            }
//            writer.writeRow(Vector(r._1, prev._1, prev._2))
//            last = r._2
//          }
//        }
//      }

      println(IO.formatNanos(maxLen * 1000 * 1000))
    }

    def hardInstructions() = {
      val state = State(GlobalOptions("/home/sheule/dev/output-strata"))
      var messages = state.getLogMessages.sortBy(x => x.time.toDate.getTime)

      // what order did we learn things in?
      val instrOrder = messages.collect({
        case LogEquivalenceClasses(instr, _, _, _) => instr
      })
      val base = state.getInstructionFile(InstructionFile.Base)
      IO.writeFile(new File("instruction-order.txt"), (base ++ instrOrder).mkString("\n"), overwrite = true)

      val data = instrOrder.map(i => {
        val meta = state.getMetaOfInstr(i)
        val firstSearch = meta.initial_searches.filter(x => x.success)
        val successfulSearchCost = firstSearch.map(x => x.iterations) ++
          meta.secondary_searches.filter(x => x.n_found > 0).map(x => x.iterations)
        (i, Stats.median(successfulSearchCost), Stats.mean(successfulSearchCost), firstSearch(0).start_ptime)
      }).sortBy(x => x._2).reverse

      val dataStr = Seq("instruction\tmedian iterations for successful search\tmean iterations for successful search\tnumber of instructions in base set at time of first search") ++
        data.map(x => f"${x._1}\t${x._2}\t${x._3}%.1f\t${x._4}")
      println(dataStr.take(10).mkString("\n"))
      IO.writeFile(new File("instruction-hardness-data.txt"), dataStr.mkString("\n"), overwrite = true)

      // output live out and def in
      val liveout = instrOrder.map(x => s"$x: live_out=${state.getMetaOfInstr(x).live_out}, def_in=${state.getMetaOfInstr(x).def_in}")
      IO.writeFile(new File("live-info.txt"), liveout.sorted.mkString("\n"), overwrite = true)
    }

    //    computeTimeSpentDoingX()
    //    computeProgress()
    //    instructionsLearnedPreviously()
    //    investigateEqClasses()
    hardInstructions()
  }

  case class InstructionStats(instr: String,
                              is_base: Boolean, strata_support: Boolean, stoke_support: Boolean, strata_reason: Int,
                              used_for: Int, strata: Option[Score], strata_long: Option[Score],
                              stoke: Option[Score], delim: Int) {
    override def toString = {
      if (strata_support && stoke_support) {
        s"$instr: ${stoke.get} / ${strata.get} (used for ${used_for + 1})"
      } else {
        s"$instr (used for ${used_for + 1})"
      }
    }
  }

  def readInstructionStatsBase: (Seq[InstructionStats], Seq[InstructionStats]) = {
    val data = for (line <- IO.readFile(new File("bin/statistics-regs.json")).split("\n")) yield {
      implicit val formats = DefaultFormats
      parse(line).extract[InstructionStats]
    }
    val data2 = for (line <- IO.readFile(new File("bin/statistics-imm8.json")).split("\n")) yield {
      implicit val formats = DefaultFormats
      parse(line).extract[InstructionStats]
    }
    (data, data2)
  }

  def readInstructionStats: Map[Instruction, InstructionStats] = {
    val (a, b) = readInstructionStatsBase
    (a ++ b).filter(x => x.instr != "<label>").map(x => Instruction(x.instr) -> x).toMap
  }

  def processSpecgenStats(baseSet: Seq[Instruction]): Unit = {
    val (data, data2) = readInstructionStatsBase
    println("Detecting differences in the number of uninterpreted functions (UIF) and use of non-linear arithmetic:")
    for (instr <- data ++ data2) {
      //      if (instr.strata_support && instr.stoke_support && instr.stoke.get.nodes > 0) {
      //        println((instr.stoke.get.nodes - instr.strata.get.nodes).abs.toDouble / instr.stoke.get.nodes)
      //      }
      //      if (!instr.stoke_support && instr.strata_support) {
      //        println(instr)
      //      }
      if (instr.stoke.nonEmpty && instr.strata.nonEmpty) {
        val s0 = instr.stoke.get
        val s1 = instr.strata.get
        if (s0.uif != s1.uif) {
          println(s"Formula from ${instr.instr} (used for ${instr.used_for + 1} instruction variants):")
          println(s"  hand-written formula: ${s0.uif} UIFs")
          println(s"  strata formula:       ${s1.uif} UIFs")
        }
        if (s0.mult != s1.mult) {
          println(s"Formula from ${instr.instr} (used for ${instr.used_for + 1} instruction variants):")
          println(s"  hand-written formula: ${s0.mult} non-linear arithmetic operations")
          println(s"  strata formula:       ${s1.mult} non-linear arithmetic operations")
        }
      }
    }

    println("\n")
    //    val check = Check(EvaluateOptions())
    //    for (instr <- data) {
    //      if (check.missingLemma.contains(instr.instr)) {
    //        println(s"${instr.instr} is used ${instr.used_for+1} times")
    ////        assert(instr.used_for == 1)
    //      }
    //      if (check.stokeIsWrong.contains(instr.instr)) {
    ////        println(s"${instr.instr} is used ${instr.used_for+1} times")
    //        assert(instr.used_for == 1)
    //      }
    //    }
    // all three absolut sizes
    val rows = (for (instr <- data if instr.stoke.nonEmpty && instr.strata.nonEmpty) yield {
      //      if (instr.strata_support && instr.stoke_support && instr.stoke.get.nodes > 0) {
      //        println((instr.stoke.get.nodes - instr.strata.get.nodes).abs.toDouble / instr.stoke.get.nodes)
      //      }
      val s0 = instr.stoke.get
      val s1 = instr.strata.get
      val s2 = instr.strata_long.get
      (s0.nodes, s1.nodes, s2.nodes)
    }).sortBy(_._1)

//    val sizeComparison = (for (instr <- data if instr.stoke.nonEmpty && instr.strata.nonEmpty) yield {
//      //      if (instr.strata_support && instr.stoke_support && instr.stoke.get.nodes > 0) {
//      //        println((instr.stoke.get.nodes - instr.strata.get.nodes).abs.toDouble / instr.stoke.get.nodes)
//      //      }
//      val s0 = instr.stoke.get
//      val s1 = instr.strata.get
//      val s2 = instr.strata_long.get
//      (instr, s1.nodes.toDouble / s0.nodes.toDouble, s0.nodes, s1.nodes)
//    }).sortBy(_._2).reverse
    //println(sizeComparison.take(40).mkString("\n"))

    val data2Both = data2.filter(p => p.strata_support && p.stoke_support).groupBy(x => x.instr.substring(0, x.instr.lastIndexOf("_")))
    val data2Strata = data2.filter(p => p.strata_support).groupBy(x => x.instr.substring(0, x.instr.lastIndexOf("_")))

    // compute relative increase
    val strataInc = (for (instr <- data if instr.stoke.nonEmpty && instr.strata.nonEmpty) yield {
      val n0 = instr.stoke.get.nodes
      val n1 = instr.strata.get.nodes
      val res = if (n0 == n1) {
        1
      } else {
        n1.toDouble / n0.toDouble
      }
      //      if (res > 5) {
      //        println(instr)
      //      }
      List.fill(instr.used_for + 1)(res)
    }).flatten ++ (for ((instr, list) <- data2Both) yield {
      val n = list.length
      val n0 = list.map(x => x.strata.get.nodes).sum.toDouble / n.toDouble
      val n1 = list.map(x => x.strata.get.nodes).sum.toDouble / n.toDouble
      val res = if (n0 == n1) {
        1
      } else {
        n1 / n0
      }
      List.fill(list.head.used_for + 1)(res)
    }).flatten
    val simpleInc = (for (instr <- data if instr.strata_long.nonEmpty && instr.strata.nonEmpty) yield {
      val n0 = instr.strata.get.nodes
      val n1 = instr.strata_long.get.nodes
      val res = if (n0 == n1) {
        1
      } else {
        n1.toDouble / n0.toDouble
      }
      List.fill(instr.used_for + 1)(res)
    }).flatten ++ (for ((instr, list) <- data2Strata) yield {
      val n = list.length
      val n0 = list.map(x => x.strata.get.nodes).sum.toDouble / n.toDouble
      val n1 = list.map(x => x.strata.get.nodes).sum.toDouble / n.toDouble
      val res = if (n0 == n1) {
        1
      } else {
        n1 / n0
      }
      List.fill(list.head.used_for + 1)(res)
    }).flatten

    println("Computing size comparison data...")

    for (writer <- managed(CSVWriter.open(new File("bin/strata-increase.csv")))) {
      for (r <- strataInc) {
        writer.writeRow(Vector(r))
      }
    }
    println(Stats.describe(strataInc, "Distribution of (strata size / hand-written size)"))
    for (writer <- managed(CSVWriter.open(new File("bin/strata-simplication-increase.csv")))) {
      for (r <- simpleInc) {
        writer.writeRow(Vector(r))
      }
    }
    println()
    println(Stats.describe(simpleInc, "Distribution of (non-simplified strata size / strata size)"))
    //    println(Stats.describe(rows.map(_._1), "hand-written formula size"))
    //    println(Stats.describe(rows.map(_._2), "strata formula size"))
    println()
    println(s"Maximum size for hand-written formulas: ${rows.map(_._1).max}")
    println(s"Maximum size for strata formulas: ${rows.map(_._2).max}")

    println(s"Strata formulas that are smaller:  ${strataInc.count(x => x < 1)}")
    println(s"Strata formulas that are the same size: ${strataInc.count(x => x == 1)}")
    println(s"Strata formulas that are larger:   ${strataInc.count(x => x > 1)}")

    val immDistribution = data2.filter(p => p.strata_support).groupBy(x => x.instr.substring(0, x.instr.lastIndexOf("_")))
    //    for ((i, j) <- immDistribution) {
    //      println(s"$i: ${j.length}")
    //    }

    println("\nTable from the paper:")
    val imm8 = data2.map(x => if (x.strata_support) x.used_for + 1 else 0).sum.toDouble / 256.0
    val table =
      f"""
         |Base set                           &  ${data.count(x => x.strata_reason == 0)}\\\\
         |Pseudo instruction templates       &  11\\\\
         |\\midrule
         |Register-only variants learned      &  ${data.count(x => x.strata_reason == 1)}\\\\
         |Generalized (same-sized operands)  &  ${data.count(x => x.strata_reason == 2)}\\\\
         |Generalized (extending operands)   &  ${data.count(x => x.strata_reason == 3)}\\\\
         |Generalized (shrinking operands)   &  ${data.count(x => x.strata_reason == 4)}\\\\
         |8-bit constant instructions learned &  $imm8%.2f\\\\
         |\\midrule
         |\\textbf{Learned formulas in total} &  \\textbf{${data.count(x => x.strata_reason > 0) + imm8}%.2f}\\\\
         |""".stripMargin
    println(table)
    IO.writeFile(new File("bin/result-table.tex"), table)
  }

  /** Collect data for further analysis. */
  def collectData(evalOptions: EvaluateOptions): Unit = {
    val regState = State(GlobalOptions(workdirPath = s"${evalOptions.dataPath}/data-regs"))
    val messages = regState.getLogMessages

    val extstats = getExtendedStats(messages)
    def printBox(b: Box) = {
      val (o, _) = printBoxesHorizontally(Vector(b), 45)
      println(o)
    }
    printBox(extstats.otherInfoBox)
    printBox(extstats.searchOverviewBox)
    printBox(extstats.timingBox)
    printBox(extstats.validatorInvocationsBox)
    println()

    // determine start times (taking into account breaks between entry points)
    val (runSoFar, offsets) = computeOffsets(messages)

    //    val successes = messages.collect({
    ////      case LogTaskEnd(_, Some(s: InitialSearchSuccess), _, _, _) =>
    ////        s.task.instruction
    //      case LogEquivalenceClasses(instr, _, _, _) =>
    //        instr
    //    })
    //    println(successes)
    //    println(successes.size)

    // process output form specgen_statistics
    val baseSet = regState.getInstructionFile(InstructionFile.Base)
    processSpecgenStats(baseSet)

    // levels
    val check = Check(evalOptions)
    val (strataInstrs, graph) = check.dependencyGraph(evalOptions.circuitPath)
    val difficultyMap: Map[Instruction, Int] = check.computeDifficultyMap(baseSet)
    val difficultyDist = difficultyMap.values.map(_.toLong).toSeq
    for (writer <- managed(CSVWriter.open(new File("bin/levels.csv")))) {
      for (level <- difficultyMap.values) {
        writer.writeRow(Vector(level))
      }
    }
    val lvls = difficultyDist.filter(_ > 0).sorted
    val nlvl = lvls.length
    println(f"Percentage of instructions learned at stratum 1: ${lvls.count(_ <= 1).toDouble * 100.0 / nlvl.toDouble}%.2f")
    println(f"50th percentile is at stratum ${lvls((0.5 * nlvl).round.toInt)}")
    println(f"90th percentile is at stratum ${lvls((0.9 * nlvl).round.toInt)}")

    // search progress
    println()
    println("Computing information about the search progress...")
    val progressRows = messages.collect {
      case LogTaskEnd(_, _, pt, time, ctx) if pt > 0 =>
        val tInMs = timeSinceStart(time, offsets)
        (tInMs.toDouble / (1000d * 60d * 60d), pt)
    }.sortBy(x => x._1)
    val baseSetSize = progressRows.map(_._2).min
    // optimize by dropping intermediate unchanged elements
    for (writer <- managed(CSVWriter.open(new File("bin/progress.csv")))) {
      var last = -1
      for ((r, i) <- progressRows.zipWithIndex) {
        if (r._2 != last || i == 0 || i == progressRows.size - 1) {
          writer.writeRow(Vector(r._1, r._2 - baseSetSize))
          last = r._2
        }
      }
    }
    val wallHoursRegs = runSoFar.toDouble / (1000d * 60d * 60d)
    println(f"Experiment to learn register-only variants ran for ${wallHoursRegs}%.2f hours")

    // calculate imm8 running time
    var runTime = 0L
    for (i <- 0 to 7) {
      print(".")
      val imm8State = State(GlobalOptions(workdirPath = s"${evalOptions.dataPath}/data-imm8/block-$i"))
      val immMessages = imm8State.getLogMessages.map(x => x.time.toDate.getTime)
      runTime += immMessages.max - immMessages.min
    }
    println()
    val wallHoursImm8 = runTime.toDouble / (1000d * 60d * 60d)
    println(f"Experiment to learn imm8 instructions ran for ${wallHoursImm8}%.2f hours")

    println(f"Total runtime therefore is ${wallHoursRegs + wallHoursImm8}%.2f hours, or ${(wallHoursRegs + wallHoursImm8) * 28}%.2f CPU core hours")

    //println(s"Processed ${messages.length} messages")

    // level vs timeouts
    //    val initialTimeouts = messages.collect {
    //      case LogTaskEnd(task: InitialSearchTask, Some(_: InitialSearchTimeout), _, _, _) =>
    //        (task.instruction, task.budget)
    //    }.groupBy(x => x._1).map(x => (x._1, x._2.map(_._2)))
    //    for(writer <- managed(CSVWriter.open(new File("../data-strata/level-vs-attempts.csv")))) {
    //      for ((instr, timeouts) <- initialTimeouts) {
    //        // only do it for instruction where we succeeded
    //        if (difficultyMap.contains(instr)) {
    //          val level = difficultyMap(instr)._1
    //          writer.writeRow(Vector(instr, level, timeouts.size, timeouts.sum))
    //        }
    //      }
    //    }

    // graph initial searches
    //    val initialGraph = new File("../data-strata/initial-search.csv")
    //    val _ = {
    //      val writer = CSVWriter.open(initialGraph)
    //      for (message <- messages) {
    //        message match {
    //          case LogTaskEnd(_, Some(InitialSearchTimeout(task, timing)), pt, time, _) =>
    //            writer.writeRow(Vector(time.toDate.getTime, task.pseudoTime, task.budget))
    //          case _ =>
    //        }
    //      }
    //      writer.close()
    //    }

    // initial search budgets
    //    val budgets = messages.collect {
    //      case LogTaskEnd(InitialSearchTask(_, _, budget, _), _, _, _, _) => budget
    //    }
    //    println(Distribution(budgets.map(x => Math.log(x).toLong)).info("initial search budget"))

    // length of secondary search
    //    val sndSearch = messages.collect {
    //      case LogTaskEnd(SecondarySearchTask(_, instr, budget, _), Some(r), _, _, _) =>
    //        (instr, r.timing.search)
    //    }
    //    val totalSearchTimes = sndSearch.groupBy(x => x._1).values.map(x => x.map(_._2).sum)
    //    println(Distribution(totalSearchTimes.toSeq.map(x => x / 1000 / 1000 / 1000 / 60)).info("secondary search times"))
    //    val nn = totalSearchTimes.size
    //    if (nn > 0) {
    //      val sorted1 = totalSearchTimes.toSeq.sorted
    //      for (i <- 0 to 9) {
    //        println(s"$i: " + IO.formatNanos(sorted1(nn * 10 * i / 100)))
    //      }
    //    }

    // equivalence class statistics
    //    val eqs = messages.collect {
    //      case LogEquivalenceClasses(instr, eq, _, _) =>
    //        (instr, eq)
    //    }
    //    val firstEq = eqs.map(x => x._2.getClasses().head)
    //    val secondEq = eqs.flatMap(x => if (x._2.nClasses <= 1) None else Some(x._2.getClasses().seq(1)))
    //    println(Distribution(firstEq.map(x => x.size.toLong)).info("size of first equivalence class"))
    //    println(Distribution(secondEq.map(x => x.size.toLong)).info("size of second equivalence class"))
    //    println(Distribution(secondEq.map(x => x.size.toLong)).info("size of second equivalence class"))
    //    //println(Distribution(eqs.map(x => x._2.getClasses().map(y => y.size).sum.toLong)).info("all programs"))
    //
    //    println(Distribution(firstEq.map(x => x.getRepresentativeProgram.score.uif.toLong)).info("best program's # of UIF"))
    //    println(Distribution(firstEq.map(x => x.getRepresentativeProgram.score.mult.toLong)).info("best program's # of multiplications/divisions"))
    //    println(Distribution(firstEq.map(x => x.getRepresentativeProgram.score.nodes.toLong)).info("best program's # of nodes"))

    //    for ((instr, eq) <- eqs) {
    //      val sorted = eq.getClasses()
    //      val first = sorted.head
    //      if (first.size < 3) {
    //        println(instr)
    //        val firstProg = first.getRepresentativeProgram
    //        println(s"${first.size} -> ${firstProg.score}")
    //        println(IO.indented(Program.fromFile(firstProg.getFile(instr, state)).toString))
    //        if (sorted.length > 1) {
    //          val sndProg = sorted(1).getRepresentativeProgram
    //          println(s"${sorted(1).size} -> ${sndProg.score}")
    //          println(IO.indented(Program.fromFile(sndProg.getFile(instr, state)).toString))
    //        }
    //        println("--------")
    //      }
    //    }
  }

  /** Show statistics and update them periodically. */
  def run(globalOptions: GlobalOptions, singleRun: Boolean): Unit = {
    val state = State(globalOptions)

    sys.addShutdownHook {
      sys.exit(0)
    }

    import ExecutionContext.Implicits.global
    var messageFuture: Future[ExtendedStats] = Future {
      getExtendedStats(state.getLogMessages)
    }

    // start without parsing the log
    var extendedStats = ExtendedStats()
    while (true) {
      if (messageFuture.isCompleted) {
        messageFuture.onSuccess({
          case m =>
            extendedStats = m
            if (!singleRun) {
              messageFuture = Future {
                Thread.sleep(10000)
                getExtendedStats(state.getLogMessages)
              }
            }
        })
      }
      printStats(getStats(state), extendedStats)
      if (extendedStats.hasData && singleRun) {
        sys.exit(0)
      }
      Thread.sleep(2000)
    }
  }

  def getExtendedStats(messages: Seq[LogMessage]): ExtendedStats = {
    if (messages.isEmpty) ExtendedStats()
    else {
      val errors = messages.collect({
        case e: LogError => e
      }).length
      val failedInitial = messages.count({
        case LogTaskEnd(t, Some(res: InitialSearchTimeout), _, _, _) => true
        case _ => false
      })
      val secondary = messages.collect({
        case LogTaskEnd(t, Some(SecondarySearchSuccess(_, kind, _)), _, _, _) => kind
      })
      val timings = messages.collect({
        case LogTaskEnd(t, Some(res), _, _, _) => res.timing
      }).flatMap(x => x.data.map(identity)).groupBy(x => x._1).map(x => (x._1, x._2.map(x => x._2).sum))
      val totalTime = timings.filter(p => p._1 != TimingKind.Total).values.sum
      val totalCpuTime = timings.filter(p => p._1 == TimingKind.Total).values.sum
      val validations = messages.collect({
        case LogVerifyResult(_, true, verifyResult, _, _, _, _) => verifyResult
      })
      ExtendedStats(
        globalStartTime = IO.formatTime(messages.head.time),
        errors = errors,
        totalCpuTime = totalCpuTime,
        searchOverview = Vector(
          ("equivalent", Stats.percentage(secondary.count({
            case _: SrkEquivalent => true
            case _ => false
          }), secondary.length)),
          ("unknown", Stats.percentage(secondary.count({
            case _: SrkUnknown => true
            case _ => false
          }), secondary.length)),
          ("counterexample", Stats.percentage(secondary.count({
            case _: SrkCounterExample => true
            case _ => false
          }), secondary.length)),
          ("total", Stats.percentage(secondary.length, secondary.length))
        ),
        validatorInvocations = Vector(
          ("equivalent", Stats.percentage(validations.count(p => p.isVerified), validations.length)),
          ("unknown", Stats.percentage(validations.count(p => p.isUnknown), validations.length)),
          ("counterexample", Stats.percentage(validations.count(p => p.isCounterExample), validations.length)),
          ("timeout", Stats.percentage(validations.count(p => p.isTimeout), validations.length)),
          ("total", Stats.percentage(validations.length, validations.length))
        ),
        timing = Vector(
          ("search", Stats.percentage(timings.getOrElse(TimingKind.Search, 0), totalTime, IO.formatNanos, 13)),
          ("validation", Stats.percentage(timings.getOrElse(TimingKind.Verification, 0), totalTime, IO.formatNanos, 13)),
          ("testcases", Stats.percentage(timings.getOrElse(TimingKind.Testing, 0), totalTime, IO.formatNanos, 13)),
          ("total", Stats.percentage(totalTime, totalTime, IO.formatNanos, 13))
        ),
        otherInfo = Vector(
          ("failed initial searches", failedInitial)
        )
      )
    }
  }

  def clearConsole(): Unit = {
    print(CLEAR_CONSOLE)
    Console.flush()
  }

  def getStats(state: State): StatsData = {
    state.lockedInformation(() => {
      StatsData(
        state.getInstructionFile(InstructionFile.Base, includeWorklist = true).length,
        state.getInstructionFile(InstructionFile.Success, includeWorklist = true).length,
        state.getInstructionFile(InstructionFile.PartialSuccess, includeWorklist = true).length,
        state.getInstructionFile(InstructionFile.Worklist, includeWorklist = true).length,
        state.getInstructionFile(InstructionFile.RemainingGoal, includeWorklist = true).length,
        state.getInstructionFile(InstructionFile.InitialGoal, includeWorklist = true).length,
        0
      )
    })
  }

  case class StatsData(
                        nBase: Int,
                        nSuccess: Int,
                        nPartialSuccess: Int,
                        nWorklist: Int,
                        nRemainingGoal: Int,
                        nInitialGoal: Int,
                        delim: Int
                        )

  case class ExtendedStats(
                            globalStartTime: String = "n/a",
                            errors: Int = 0,
                            totalCpuTime: Long = 0,
                            searchOverview: Seq[(Any, Any)] = Nil,
                            validatorInvocations: Seq[(Any, Any)] = Nil,
                            timing: Seq[(Any, Any)] = Nil,
                            otherInfo: Seq[(Any, Any)] = Nil
                            ) {
    def hasData = searchOverview.nonEmpty

    def searchOverviewBox = Box.mk("Successful search overview", searchOverview)

    def validatorInvocationsBox = Box.mk("Validator invocations", validatorInvocations)

    def timingBox = Box.mk("Cpu time distribution", timing)

    def otherInfoBox = Box.mk("Additional information", otherInfo)
  }

  case class Box(title: String, labelsAny: Seq[Any], dataAny: Seq[Any]) {

    val labels = labelsAny map (x => x.toString)
    val data = dataAny map (x => x.toString)

    val maxLabel: Int = {
      labels.map(x => ColoredOutput.uncoloredLength(x)).max
    }

    val width = {
      Seq(
        maxLabel + 2 + data.map(x => ColoredOutput.uncoloredLength(x)).max,
        title.length
      ).max
    }

    val lines = labels.length

    def renderTitle = title.color(14) + (" " * (width - title.length))

    def renderLine(i: Int): String = {
      if (i == -1) return renderTitle
      val label = labels(i)
      val res = new StringBuilder()
      res.append(" " * (maxLabel - label.length))
      res.append(label.gray)
      res.append(": ".gray)
      res.append(data(i))
      res.append(" " * (width - ColoredOutput.uncoloredLength(res.toString())))
      res.toString()
    }
  }

  object Box {
    def mk(name: String, data: Seq[(Any, Any)]) = {
      Box(name, data.map(_._1), data.map(_._2))
    }
  }

  def printStats(stats: StatsData, extendedStats: ExtendedStats): Unit = {
    val width = getConsoleWidth
    def horizontalLine(dividerDown: Seq[Int] = Nil, dividerUp: Seq[Int] = Nil): String = {
      val res = new StringBuilder()
      def select(idx: Int, options: Seq[String]): String = {
        if (dividerDown.contains(idx)) {
          if (dividerUp.contains(idx)) options(0) else options(1)
        } else {
          if (dividerUp.contains(idx)) options(2) else options(3)
        }
      }
      res.append(select(-1, Vector("├", "┌", "└", "─")))
      for (i <- 0 to (width - 1)) {
        res.append(select(i, Vector("┼", "┬", "┴", "─")))
      }
      res.append(select(width, Vector("┤", "┐", "┘", "─")))
      res.toString()
    }

    clearConsole()
    val header =
      " ____  ____  ____   __  ____  __  \n/ ___)(_  _)(  _ \\ / _\\(_  _)/ _\\ \n\\___ \\  )(   )   //    \\ )( /    \\\n(____/ (__) (__\\_)\\_/\\_/(__)\\_/\\_/"
    val headerLines = header.split("\n")
    val headerWidth = headerLines(0).length
    for ((line, i) <- headerLines.zipWithIndex) {
      print(" " * 4)
      print(line)
      if (i == headerLines.length - 1) print(s"   strata [git hash ${IO.getGitHash.substring(0, 12)}]")
      println("")
    }

    val progress = Vector(
      (stats.nBase, "base", (x: String) => x.color(240)),
      (stats.nSuccess - stats.nBase, "success", (x: String) => x.color(28)),
      (stats.nPartialSuccess, "partial success", (x: String) => x.color(21)),
      (stats.nRemainingGoal, "remaining", (x: String) => x.color(124))
    )
    val total = progress.map(x => x._1).sum.toDouble

    val beginEnd = Vector(-1, width)
    println(horizontalLine(beginEnd).gray)
    print("│ ".gray)
    var cur = 0.0
    for ((p, i) <- progress.zipWithIndex) {
      val char = if (i == progress.length - 1) "█" else "█"
      print(p._3(char) * (cur + p._1.toDouble / total * (width - 2) - cur.round.toInt).round.toInt)
      cur += p._1.toDouble / total * (width - 2)
    }
    println(" │".gray)

    val progressBox = Box("Progress", progress.map(x => x._2), progress.map(x => {
      f"${x._1}%4d (${x._1.toDouble * 100.0 / total}%5.2f %%) " + x._3("█")
    }))

    val globalStartTime = extendedStats.globalStartTime

    val errorStr = if (extendedStats.errors > 0) extendedStats.errors.toString.red else "0"
    val basicBox = Box("Basic information",
      Vector("started at", "cpu time", "running threads", "number of errors"),
      Vector(globalStartTime, IO.formatNanos(extendedStats.totalCpuTime), stats.nWorklist, errorStr))

    val (out, breaks) = printBoxesHorizontally(Vector(progressBox, basicBox), width)

    println(horizontalLine(beginEnd ++ breaks, beginEnd).gray)
    print(out)

    val lastBreaks = if (extendedStats.hasData) {
      val (out2, breaks2) = printBoxesHorizontally(
        Vector(extendedStats.searchOverviewBox, extendedStats.timingBox), width)

      println(horizontalLine(beginEnd ++ breaks2, beginEnd ++ breaks).gray)
      print(out2)

      val (out3, breaks3) = printBoxesHorizontally(
        Vector(extendedStats.validatorInvocationsBox, extendedStats.otherInfoBox), width)

      println(horizontalLine(beginEnd ++ breaks3, beginEnd ++ breaks2).gray)
      print(out3)
      breaks3
    } else {
      breaks
    }

    println(horizontalLine(Nil, beginEnd ++ lastBreaks).gray)
  }

  def printBoxesHorizontally(boxes: Vector[Box], width: Int): (String, Seq[Int]) = {
    val res = new StringBuilder()
    val breaks = new ListBuffer[Int]()

    val lines = boxes.map(x => x.lines).max
    for (i <- 0 to lines) {
      res.append("│".gray)
      res.append(" ")
      var cur = 0
      for (j <- 1 to boxes.length) {
        val box = boxes(j - 1)
        if (j != 1) {
          res.append(" ")
          res.append("│".gray)
          res.append(" ")
          cur += 3
        }
        cur += box.width
        if (i <= box.lines) {
          res.append(box.renderLine(i - 1))
        } else {
          res.append(" " * box.width)
        }
        if (j != boxes.length && i == 0) {
          breaks.append(cur + 2)
        }
      }
      res.append(" " * (width - cur - 1))
      res.append("│".gray)
      res.append("\n")
    }
    (res.toString(), breaks.toList)
  }

  def getConsoleWidth: Int = {
    80
  }
}
