package denali

import denali.data.{InstructionFile, Instruction, State}
import denali.util.{ColoredOutput, IO}
import ColoredOutput._

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
    printStats(getStats(state))

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

  case class Box(title: String, labels: Seq[String], data: Seq[String]) {

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
      res.toString()
    }
  }

  def printStats(stats: Stats): Unit = {
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
      (stats.nSuccess, "success", (x: String) => x.color(28)),
      (stats.nPartialSuccess + 100, "partial success", (x: String) => x.color(21)),
      (stats.nRemainingGoal, "remaining", (x: String) => x.color(124))
    )
    val total = progress.map(x => x._1).sum.toDouble

    val beginEnd = Vector(-1, width)
    println(horizontalLine(beginEnd).gray)
    print("│ ".gray)
    var cur = 0.0
    for ((p, i) <- progress.zipWithIndex) {
      val char = if (i == progress.length - 1) "█" else "█"
      print(p._3(char) * (((cur - cur.round.toInt) + p._1.toDouble) / total * width).round.toInt)
      cur += p._1.toDouble / total * width
    }
    println(" │".gray)

    val progressBox = Box("Progress", progress.map(x => x._2), progress.map(x => {
      f"${x._1}%4d (${x._1.toDouble * 100.0 / total}%5.2f %%) " + x._3("█")
    }))

    val basicBox = Box("Basic information",
      Vector("running since", "running threads"),
      Vector("?", s"${stats.nWorklist}"))

    val (out, breaks) = printBoxesHorizontally(Vector(progressBox, basicBox), width)

    println(horizontalLine(beginEnd ++ breaks, beginEnd).gray)
    print(out)
    println(horizontalLine(Nil, beginEnd ++ breaks).gray)
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
        cur += box.width + 2
        if (j != 1) {
          res.append(" ")
          res.append("│".gray)
          res.append(" ")
        }
        if (j != boxes.length && i == 0) {
          breaks.append(cur)
        }
        if (i <= box.lines) {
          res.append(box.renderLine(i - 1))
        } else {
          res.append(" " * box.width)
        }
      }
      res.append(" " * (width - cur))
      res.append("│".gray)
      res.append("\n")
    }
    (res.toString(), breaks.toList)
  }

  def getConsoleWidth: Int = {
    80
  }
}
