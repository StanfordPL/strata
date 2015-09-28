package denali.data

import java.io.{FileWriter, File}
import java.util.Calendar
import denali.GlobalOptions
import scala.collection.mutable.ListBuffer
import scala.io.{BufferedSource, Source}
import denali.util.{IO, Locking}
import org.json4s._
import org.json4s.native.JsonMethods._

/**
 * Code to interact with the state of a denali run (stored on disk).
 */
class State(cmdOptions: GlobalOptions) {

  /** Move an instruction to the worklist. */
  def moveToWorklist(instr: Instruction) = {
    writeInstructionFile(State.PATH_WORKLIST, getWorklistInstrs ++ Seq(instr))
  }

  /** Get all the remaining goal instructions. */
  def getGoalInstrs(includeWorklist: Boolean = false): Seq[Instruction] = getInstructionFile(State.PATH_GOAL)

  /** Get all the instructions with partial success. */
  def getPartialSuccessInstrs(includeWorklist: Boolean = false): Seq[Instruction] = getInstructionFile(State.PATH_GOAL)

  /** Get all the instructions for which the search already succeeded. */
  def getSuccessInstr(excludeBase: Boolean = false): Seq[Instruction] = {
    if (excludeBase) getInstructionFile(State.PATH_SUCCESS)
    else getInstructionFile(State.PATH_SUCCESS) ++ getInstructionFile(State.PATH_INITIAL_BASE)
  }

  /** Get all the instructions in the worklist. */
  def getWorklistInstrs: Seq[Instruction] = getInstructionFile(State.PATH_WORKLIST, includeWorklist = true)

  /** Read an instruction file. */
  private def getInstructionFile(path: String, includeWorklist: Boolean = false): Seq[Instruction] = {
    val exclude = if (includeWorklist) {
      Nil
    } else {
      getWorklistInstrs
    }
    def isExcluded(opcode: String): Boolean = {
      for (e <- exclude) {
        if (opcode == e.opcode) return true
      }
      false
    }

    val file = Source.fromFile(s"${cmdOptions.workdir}/$path")
    val lines = file.getLines()
    var res = ListBuffer[Instruction]()
    for (line <- file.getLines()) {
      val opcode = line.stripLineEnd
      if (!isExcluded(opcode))
        res += new Instruction(opcode, cmdOptions)
    }
    file.close()
    res.toSeq
  }

  /** Overwrite an instruction file with new contents. */
  private def writeInstructionFile(path: String, instructions: Seq[Instruction]): Unit = {
    IO.writeFile(new File(s"${cmdOptions.workdir}/$path"), instructions.mkString("\n"))
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

  /** Lock the information directory. */
  def lockInformation(): Unit = {
    Locking.lockDir(new File(s"${cmdOptions.workdir}/${State.PATH_INFO}"))
  }

  /** Unlock the information directory. */
  def unlockInformation(): Unit = {
    Locking.lockDir(new File(s"${cmdOptions.workdir}/${State.PATH_INFO}"))
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
  private val PATH_GOAL = s"$PATH_INFO/remaining_goal.instrs"
  private val PATH_WORKLIST = s"$PATH_INFO/worklist.instrs"
  private val PATH_PARTIAL_SUCCESS = s"$PATH_INFO/partial_success.instrs"
  private val PATH_SUCCESS = s"$PATH_INFO/success.instrs"
  private val PATH_INITIAL_BASE = s"$PATH_INFO/initial_base.instrs"
  private val PATH_INITIAL_GAOL = s"$PATH_INFO/initial_goal.instrs"
  private val PATH_ALL = s"$PATH_INFO/all.instrs"
  private val PATH_LOG = s"$PATH_INFO/log.txt"
  private val PATH_FUNCTIONS = "functions"
  private val PATH_TESTCASES = "testcases.tc"
}
