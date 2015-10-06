package denali.data

import java.io.{FileWriter, File}
import java.util.Calendar
import denali.GlobalOptions
import org.json4s.native.Serialization
import org.json4s.native.Serialization.write
import scala.collection.mutable.ListBuffer
import scala.io.{BufferedSource, Source}
import denali.util.{IO, Locking}
import org.json4s._
import org.json4s.native.JsonMethods._

object InstructionFile extends Enumeration {
  type InstructionFile = Value
  val RemainingGoal, InitialGoal, Worklist, PartialSuccess, Success, Base = Value
}

import InstructionFile._

/**
 * Code to interact with the state of a denali run (stored on disk).
 */
class State(val globalOptions: GlobalOptions) {

  private val signal = new File(s"${globalOptions.workdir}/${State.PATH_SHUTDOWN}")

  /** Signal that all threads should shut down. */
  def signalShutdown(): Unit = {
    if (!signal.exists()) {
      signal.createNewFile()
    }
  }

  /** Should all threads stop? */
  def signalShutdownReceived = signal.exists()

  /** Get the current pseudo time. */
  def getPseudoTime = getInstructionFile(InstructionFile.Success).length

  /** Run a function with the information directory being locked. */
  def lockedInformation[A](f: () => A): A = {
    Locking.lockDir(getInfoPath)
    try {
      f()
    } finally {
      Locking.unlockDir(getInfoPath)
    }
  }

  /** Add an instruction to a file. */
  def addInstructionToFile(instr: Instruction, file: InstructionFile) = {
    writeInstructionFile(file, getInstructionFile(file) ++ Seq(instr))
  }

  /** Remove an instruction from a file. */
  def removeInstructionToFile(instr: Instruction, file: InstructionFile) = {
    val old = getInstructionFile(file, includeWorklist = true)
    assert(old.contains(instr))
    writeInstructionFile(file, old.filter(x => x != instr))
  }

  private def getPathForFile(file: InstructionFile): String = {
    file match {
      case RemainingGoal => State.PATH_GOAL
      case InitialGoal => State.PATH_INITIAL_GAOL
      case Worklist => State.PATH_WORKLIST
      case PartialSuccess => State.PATH_PARTIAL_SUCCESS
      case Success => State.PATH_SUCCESS
      case Base => State.PATH_INITIAL_BASE
    }
  }

  /** Read an instruction file. */
  def getInstructionFile(file: InstructionFile, includeWorklist: Boolean = false): Seq[Instruction] = {
    val path = getPathForFile(file)
    val exclude = if (includeWorklist || file == InstructionFile.Worklist) {
      Nil
    } else {
      getInstructionFile(InstructionFile.Worklist)
    }
    def isExcluded(opcode: String): Boolean = {
      for (e <- exclude) {
        if (opcode == e.opcode) return true
      }
      false
    }

    val f = Source.fromFile(s"${globalOptions.workdir}/$path")
    var res = ListBuffer[Instruction]()
    for (line <- f.getLines()) {
      val opcode = line.stripLineEnd
      if (!isExcluded(opcode))
        res += new Instruction(opcode)
    }
    f.close()
    res.toSeq
  }

  /** Overwrite an instruction file with new contents. */
  def writeInstructionFile(file: InstructionFile, instructions: Seq[Instruction]): Unit = {
    val path = getPathForFile(file)
    IO.writeFile(new File(s"${globalOptions.workdir}/$path"), instructions.mkString("\n"))
  }

  /** Has the state already been set up? */
  def exists: Boolean = {
    getInfoPath.exists
  }

  /** Returns the path to the info directory. */
  def getInfoPath: File = {
    new File(s"${globalOptions.workdir}/${State.PATH_INFO}/")
  }

  /** Add an entry to the global log file. */
  def appendLog(logMessage: LogMessage): Unit = {
    if (!exists) IO.error("state has not been initialized yet")

    def writeMessage(file: File, message: String): Unit = {
      if (!file.exists()) {
        file.createNewFile()
      }
      val writer = new FileWriter(file, true)
      writer.append(s"$message\n")
      writer.close()
    }
    Locking.lockedFile(getLogFile)(() => {
      writeMessage(getReadableLogFile, logMessage.toString)
      writeMessage(getLogFile, s"${Log.serializeMessage(logMessage)}")
    })
  }

  def getLogMessages: Seq[LogMessage] = {
    Locking.lockedFile(getLogFile)(() => {
      val s = IO.readFile(getLogFile).split("\n")
      s map (line => Log.deserializeMessage(line))
    })
  }

  def appendLogOld(msg: String): Unit = {
    if (!exists) IO.error("state has not been initialized yet")

    val file = getReadableLogFile
    Locking.lockFile(file)
    if (!file.exists()) {
      file.createNewFile()
    }
    val writer = new FileWriter(file, true)
    val time = Calendar.getInstance().getTime
    val messsage = msg.replace("\n", "\\n")
    writer.append(s"[ $time / ${ThreadContext.self}} ] $messsage\n")
    writer.close()
    Locking.unlockFile(file)
  }

  /** Get the log file. */
  private def getLogFile: File = {
    new File(s"${globalOptions.workdir}/${State.PATH_LOG}")
  }
  /** Get the log file. */
  private def getReadableLogFile: File = {
    new File(s"${globalOptions.workdir}/${State.PATH_READABLE_LOG}")
  }

  /** Add an entry to the global log file of something unexpected that happened. */
  def appendLogUnexpected(msg: String): Unit = {
    appendLogOld(s"UNEXPECTED: $msg")
  }

  /** Temporary directory for things currently running */
  def getTmpDir: File = {
    new File(s"${globalOptions.workdir}/${State.PATH_TMP}")
  }

  /** Get the path to the target assembly file for a goal instruction. */
  def getTargetOfInstr(instruction: Instruction) = {
    s"${globalOptions.workdir}/instructions/$instruction/$instruction.s"
  }

  /** Get a fresh name for a result. */
  def getFreshResultName(instruction: Instruction): File = {
    val resDir = new File(s"${globalOptions.workdir}/instructions/$instruction/results")
    if (!resDir.exists()) {
      resDir.mkdir()
    }
    var i = 0
    while (true) {
      val file = new File(f"$resDir/result-$i%05d.s")
      if (!file.exists()) {
        return file
      }
      i += 1
    }
    assert(false)
    null
  }

  /** Read the meta information for an instruction. */
  def getMetaOfInstr(instruction: Instruction): InstructionMeta = {
    implicit val formats = DefaultFormats
    val file = new File(s"${globalOptions.workdir}/instructions/$instruction/$instruction.meta.json")
    parse(IO.readFile(file)).extract[InstructionMeta]
  }

  def writeMetaOfInstr(instruction: Instruction, meta: InstructionMeta): Unit = {
    implicit val formats = Serialization.formats(NoTypeHints)
    val file = new File(s"${globalOptions.workdir}/instructions/$instruction/$instruction.meta.json")
    IO.writeFile(file, write(meta))
  }

  /** Get the number of pseudo instructions. */
  def getNumPseudoInstr: Int = {
    new File(s"${globalOptions.workdir}/${State.PATH_FUNCTIONS}").list().length
  }

  /** The path to the testcases file. */
  def getTestcasePath: File = {
    new File(s"${globalOptions.workdir}/${State.PATH_TESTCASES}")
  }

  /** Cleanup working directory. */
  def cleanup(): Unit = {
    // remove old lock files
    Locking.cleanupDir(getInfoPath)
    Locking.cleanupFile(getLogFile)

    // remove stuff from workfiles
    val worklist = getInstructionFile(InstructionFile.Worklist)
    if (worklist.nonEmpty) {
      IO.info(s"Removing ${worklist.length} instructions from the worklist.")
      writeInstructionFile(InstructionFile.Worklist, Nil)
    }

    // remove signals
    if (signal.exists()) {
      IO.info("Removing shutdown signal.")
      signal.delete()
    }

    IO.info("All clear now.")
  }
}

object State {
  def apply(cmdOptions: GlobalOptions) = new State(cmdOptions)

  private val PATH_INFO = "information"
  private val PATH_TMP = "tmp"
  private val PATH_GOAL = s"$PATH_INFO/remaining_goal.instrs"
  private val PATH_WORKLIST = s"$PATH_INFO/worklist.instrs"
  private val PATH_SHUTDOWN = s"$PATH_INFO/signal.shutdown"
  private val PATH_PARTIAL_SUCCESS = s"$PATH_INFO/partial_success.instrs"
  private val PATH_SUCCESS = s"$PATH_INFO/success.instrs"
  private val PATH_INITIAL_BASE = s"$PATH_INFO/initial_base.instrs"
  private val PATH_INITIAL_GAOL = s"$PATH_INFO/initial_goal.instrs"
  private val PATH_ALL = s"$PATH_INFO/all.instrs"
  private val PATH_LOG = s"$PATH_INFO/log.bin"
  private val PATH_READABLE_LOG = s"$PATH_INFO/log.txt"
  private val PATH_FUNCTIONS = "functions"
  private val PATH_TESTCASES = "testcases.tc"
}
