package denali.data

import java.io.{FileWriter, File}
import java.util.Calendar
import denali.GlobalOptions
import scala.collection.mutable.ListBuffer
import scala.io.Source
import denali.util.{IO, Locking}
import org.json4s._
import org.json4s.native.JsonMethods._

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
    new File(s"${cmdOptions.workdir}/${State.PATH_INFO}/").exists
  }

  /** Add an entry to the global log file. */
  def appendLog(msg: String): Unit = {
    if (!exists) IO.error("state has not been initialized yet")

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

  /** Add an entry to the global log file of something unexpected that happened. */
  def appendLogUnexpected(msg: String): Unit = {
    appendLog(s"UNEXPECTED: $msg")
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

  /** The state directory */
  def getStateDir: File = {
    new File(s"${cmdOptions.workdir}/${State.PATH_INFO}")
  }

  /** Temporary directory for things currently running */
  def getTmpDir: File = {
    new File(s"${cmdOptions.workdir}/${State.PATH_TMP}")
  }

  /** Get the path to the target assembly file for a goal instruction. */
  def getTargetOfInstr(instruction: Instruction) = {
    s"${cmdOptions.workdir}/instructions/$instruction/$instruction.s"
  }

  /** Read the meta information for an instruction. */
  def getMetaOfInstr(instruction: Instruction): InstrMeta = {
    implicit val formats = DefaultFormats
    val file = new File(s"${cmdOptions.workdir}/instructions/$instruction/$instruction.meta.json")
    parse(IO.readFile(file)).extract[InstrMeta]
  }

  /** Get the number of pseudo instructions. */
  def getNumPseudoInstr: Int = {
    new File(s"${cmdOptions.workdir}/${State.PATH_FUNCTIONS}").list().length
  }

  /** The path to the testcases file. */
  def getTestcasePath: File = {
    new File(s"${cmdOptions.workdir}/${State.PATH_TESTCASES}")
  }
}

object State {
  def apply(cmdOptions: GlobalOptions) = new State(cmdOptions)

  private val PATH_INFO = "information"
  private val PATH_TMP = "tmp"
  private val PATH_GOAL = s"$PATH_INFO/goal.txt"
  private val PATH_ALL = s"$PATH_INFO/all.txt"
  private val PATH_LOG = s"$PATH_INFO/log.txt"
  private val PATH_FUNCTIONS = "functions"
  private val PATH_TESTCASES = "testcases.tc"
}
