package denali.data

import java.io.{FileWriter, File}
import java.util.Calendar
import denali.GlobalOptions
import scala.collection.mutable.ListBuffer
import scala.io.Source
import denali.util.{IO, Locking}

/**
 * Code to interact with the state of a denali run (stored on disk).
 */
class State(cmdOptions: GlobalOptions) {

  /** Get all the goal instructions. */
  def getGoal: Seq[Instruction] = {
    val file = Source.fromFile(s"${cmdOptions.workdir}/${State.PATH_GOAL}")
    val lines = file.getLines()
    var res = ListBuffer[Instruction]()
    for (line <- file.getLines()) {
      res += new Instruction(line.stripLineEnd, cmdOptions)
    }
    file.close()
    res.toSeq
  }

  /** Has the state already been set up? */
  def exists: Boolean = {
    new File(s"${cmdOptions.workdir}/${State.PATH_STATE}/").exists
  }

  /** Add an entry to the global log file. */
  def appendLog(msg: String): Unit = {
    val file = new File(s"${cmdOptions.workdir}/${State.PATH_LOG}")
    Locking.lockFile(file)
    if (!file.exists()) {
      file.createNewFile()
    }
    val writer = new FileWriter(file, true)
    val time = Calendar.getInstance().getTime
    writer.append(s"[ $time / ${IO.getExecContextId}} ] $msg\n")
    writer.close()
    Locking.unlockFile(file)
  }

  /** Create an instruction and check that it actually exists. */
  def mkInstruction(opcode: String): Option[Instruction] = {
    val file = Source.fromFile(s"${cmdOptions.workdir}/${State.PATH_ALL}")
    try {
      for (o <- file.getLines()) {
        if (o == opcode) return Some(new Instruction(opcode, cmdOptions))
      }
      None
    } finally {
      file.close()
    }
  }

  def getStateDir: File = {
    new File(s"${cmdOptions.workdir}/${State.PATH_STATE}")
  }
}

object State {
  def apply(cmdOptions: GlobalOptions) = new State(cmdOptions)

  private val PATH_STATE = "state"
  private val PATH_GOAL = s"$PATH_STATE/goal.txt"
  private val PATH_ALL = s"$PATH_STATE/all.txt"
  private val PATH_LOG = s"$PATH_STATE/log.txt"
}
