package denali

import denali.data._
import denali.tasks.InitialSearchTimeout
import denali.util.{ColoredOutput, IO}
import ColoredOutput._
import org.joda.time.DateTime
import org.joda.time.format.{PeriodFormatterBuilder, PeriodFormat}

import scala.collection.mutable.ListBuffer

/**
 * A class to collect various statistics of the current run.
 */
object Statistics {

  val CLEAR_CONSOLE: String = "\u001b[H\u001b[2J"

  /** Show statistics and update them periodically. */
  def run(globalOptions: GlobalOptions): Unit = {
    val state = State(globalOptions)

    // clear console
    clearConsole()
    printStats(state.getLogMessages, getStats(state))

  }

  def clearConsole(): Unit = {
    print(CLEAR_CONSOLE)
    Console.flush()
  }

  def getStats(state: State): Stats = {
    state.lockedInformation(() => {
      Stats(
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

  case class Stats(
                    nBase: Int,
                    nSuccess: Int,
                    nPartialSuccess: Int,
                    nWorklist: Int,
                    nRemainingGoal: Int,
                    nInitialGoal: Int,
                    delim: Int
                    )

  case class Box(title: String, labelsAny: Seq[Any], dataAny: Seq[Any]) {

    val labels = labelsAny map (x => x.toString)
    val data = dataAny map (x => x.toString)

    val maxLabel: Int = {
      labels.map(x => ColoredOutput.uncoloredLength(x)).max
    }

    val width = {
      maxLabel + 2 + data.map(x => ColoredOutput.uncoloredLength(x)).max
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

  def printStats(logMessages: Seq[LogMessage], stats: Stats): Unit = {
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

    val header =
      " ____  ____  __ _   __   __    __ \n" +
        "(    \\(  __)(  ( \\ / _\\ (  )  (  )\n" +
        " ) D ( ) _) /    //    \\/ (_/\\ )( \n" +
        "(____/(____)\\_)__)\\_/\\_/\\____/(__)"
    val headerLines = header.split("\n")
    val headerWidth = headerLines(0).length
    for ((line, i) <- headerLines.zipWithIndex) {
      print(" " * 12)
      print(line)
      if (i == headerLines.length - 1) print(" denali v1.0")
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
      print(p._3(char) * (cur + p._1.toDouble/ total * (width - 2) - cur.round.toInt).round.toInt)
      cur += p._1.toDouble / total * (width - 2)
    }
    println(" │".gray)

    val progressBox = Box("Progress", progress.map(x => x._2), progress.map(x => {
      f"${x._1}%4d (${x._1.toDouble * 100.0 / total}%5.2f %%) " + x._3("█")
    }))

    val globalStartTime = if (logMessages.nonEmpty) IO.formatTime(logMessages.head.time) else "n/a"

    // compute cpu time
    val startMap = collection.mutable.Map[ThreadContext, DateTime]()
    import com.github.nscala_time.time.Imports._
    var cpuTime = new Duration(0)
    for (m <- logMessages) {
      m match {
        case start: LogStart =>
          assert(!startMap.contains(start.context))
          startMap(start.context) = start.time
        case end: LogEnd =>
          assert(startMap.contains(end.context))
          val startTime = startMap(end.context)
          val duration = startTime to end.time
          cpuTime += duration.duration
          startMap.remove(end.context)
        case _ =>
      }
    }

    val formatter = new PeriodFormatterBuilder()
      .appendDays()
      .appendSuffix("d ")
      .appendHours()
      .appendSuffix("h ")
      .appendMinutes()
      .appendSuffix("m ")
      .appendSeconds()
      .appendSuffix("s ")
      .toFormatter

    val errors = logMessages.collect({
      case e: LogError => e
    })
    val errorStr = if (errors.nonEmpty) errors.length.toString.red else "0"
    val basicBox = Box("Basic information",
      Vector("started at", "cpu time", "running threads", "number of errors"),
      Vector(globalStartTime, formatter.print(cpuTime.toPeriod), stats.nWorklist, errorStr))

    val (out, breaks) = printBoxesHorizontally(Vector(progressBox, basicBox), width)

    println(horizontalLine(beginEnd ++ breaks, beginEnd).gray)
    print(out)

    val failedInitial = logMessages.count({
      case LogTaskEnd(t, Some(InitialSearchTimeout(_)), _, _) => true
      case _ => false
    })
    val eventBox = Box("Search events", Vector("failed initial searches"), Vector(failedInitial))
    val (out2, breaks2) = printBoxesHorizontally(Vector(eventBox), width)

    println(horizontalLine(beginEnd ++ breaks2, beginEnd ++ breaks).gray)
    print(out2)
    println(horizontalLine(Nil, beginEnd ++ breaks2).gray)
  }

  def printBoxesHorizontally(boxes: Vector[Box], width: Int): (String, Seq[Int]) = {
    val res = new StringBuilder()
    val breaks=  new ListBuffer[Int]()

    val lines = boxes.map(x => x.lines).max
    for (i <- 0 to lines) {
      res.append("│".gray)
      res.append(" ")
      var cur = 0
      for (j <- 1 to boxes.length) {
        val box = boxes(j-1)
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
