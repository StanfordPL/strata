package strata.data

import java.io.{File, FileWriter}
import java.nio.file.Files

import org.json4s._
import org.json4s.native.JsonMethods._
import org.json4s.native.Serialization
import org.json4s.native.Serialization._
import strata.GlobalOptions
import strata.util.ColoredOutput._
import strata.util.{IO, Locking}

import scala.collection.mutable.ListBuffer
import scala.io.Source

object InstructionFile extends Enumeration {
  type InstructionFile = Value
  val RemainingGoal, InitialGoal, Worklist, PartialSuccess, Success, Base = Value
}

import strata.data.InstructionFile._

/**
 * Code to interact with the state of a strata run (stored on disk).
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
    writeInstructionFile(file, getInstructionFile(file, includeWorklist = true) ++ Seq(instr))
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
    def writeMessage(file: File, message: String): Unit = {
      if (!file.exists()) {
        file.createNewFile()
      }
      val writer = new FileWriter(file, true)
      writer.append(s"$message\n")
      writer.close()
    }
    this.synchronized {
      if (!exists) IO.error("state has not been initialized yet")

      if (logMessage.isInstanceOf[LogError]) {
        IO.info(logMessage.toString.red)
      }

      writeMessage(getReadableLogFile, logMessage.toString)
      writeMessage(getLogFile, s"${Log.serializeMessage(logMessage)}")
    }
  }

  def getLogMessages: Seq[LogMessage] = {
    val tmpDir = IO.getTempDir("logs")
    IO.copyDir(getLogBinDir, tmpDir)
    val res = collection.mutable.ListBuffer[LogMessage]()
    for (tmpFile <- tmpDir.listFiles()) {
      val buf = scala.io.Source.fromFile(tmpFile)
      for (line <- buf.getLines()) {
        res += Log.deserializeMessage(line)
      }
      buf.close()
    }
    IO.deleteDirectory(tmpDir)
    res.toList
  }

  private lazy val base = getInstructionFile(InstructionFile.Base)
  private val scoreCache = collection.mutable.Map[String, Score]()
  private var scoreFileContents: Seq[(String, Score)] = Nil

  def updateUifCache(): Unit = {
    implicit val formats = DefaultFormats
    val file = new File(s"$getInfoPath/${State.PATH_SCORE_CACHE}")
    if (file.exists()) {
      scoreFileContents = parse(IO.readFile(file)).extract[Seq[(String, Score)]]
      for ((opc, score) <- scoreFileContents) {
        scoreCache.put(opc, score)
      }
    } else {
      scoreCache.clear()
    }
  }

  def addScore(instruction: Instruction, score: Score): Unit = {
    updateUifCache()
    scoreFileContents = Vector((instruction.opcode, score)) ++ scoreFileContents
    implicit val formats = Serialization.formats(NoTypeHints)
    val file = new File(s"$getInfoPath/${State.PATH_SCORE_CACHE}")
    IO.writeFile(file, write(scoreFileContents))
  }

  /** Returns the score of an instruction we have already learned. */
  def usesUIF(instr: Instruction, useCache: Boolean = false): Boolean = {
    if (!useCache) {
      updateUifCache()
    }
    if (base.contains(instr)) {
      val baseUsesUIF = Vector(
        "vaddpd_ymm_ymm_ymm",
        "vaddps_ymm_ymm_ymm",
        "vcvtdq2pd_ymm_ymm",
        "vcvtdq2ps_ymm_ymm",
        "vcvtpd2dq_xmm_ymm",
        "vcvtpd2ps_xmm_ymm",
        "vcvtps2dq_ymm_ymm",
        "vcvtps2pd_ymm_xmm",
        "vcvttpd2dq_xmm_ymm",
        "vcvttps2dq_ymm_ymm",
        "vdivpd_ymm_ymm_ymm",
        "vdivps_ymm_ymm_ymm",
        "vfmadd132pd_ymm_ymm_ymm",
        "vfmadd132ps_ymm_ymm_ymm",
        "vfmsub132pd_ymm_ymm_ymm",
        "vfmsub132ps_ymm_ymm_ymm",
        "vfnmadd132pd_ymm_ymm_ymm",
        "vfnmadd132ps_ymm_ymm_ymm",
        "vfnmsub132pd_ymm_ymm_ymm",
        "vfnmsub132ps_ymm_ymm_ymm",
        "vmaxpd_ymm_ymm_ymm",
        "vmaxps_ymm_ymm_ymm",
        "vminpd_ymm_ymm_ymm",
        "vminps_ymm_ymm_ymm",
        "vmulpd_ymm_ymm_ymm",
        "vmulps_ymm_ymm_ymm",
        "vrcpps_ymm_ymm",
        "vrsqrtps_ymm_ymm",
        "vsqrtpd_ymm_ymm",
        "vsqrtps_ymm_ymm",
        "vsubpd_ymm_ymm_ymm",
        "vsubps_ymm_ymm_ymm"
      )
      return baseUsesUIF.contains(instr.opcode)
    }
    assert(scoreCache.contains(instr.opcode))
    scoreCache(instr.opcode).uif > 0
  }

  /** Get the log file. */
  private def getLogFile: File = {
    new File(s"${globalOptions.workdir}/logs-bin/${ThreadContext.self.hostname}_log.bin")
  }
  /** Get the log file. */
  private def getReadableLogFile: File = {
    new File(s"${globalOptions.workdir}/logs/${ThreadContext.self.hostname}_log.txt")
  }

  /** Temporary directory for things currently running */
  def getTmpDir: File = {
    new File(s"${globalOptions.workdir}/${State.PATH_TMP}")
  }

  /** Get the path where circuits are stored. */
  def getCircuitDir: File = {
    new File(s"${globalOptions.workdir}/${State.PATH_CIRCUITS}")
  }

  /** Get the path where logs are stored. */
  def getLogDir: File = {
    new File(s"${globalOptions.workdir}/logs")
  }
  /** Get the path where logs are stored. */
  def getLogBinDir: File = {
    new File(s"${globalOptions.workdir}/logs-bin")
  }

  /** Get the path to the target assembly file for a goal instruction. */
  def getTargetOfInstr(instruction: Instruction): File = {
    new File(s"${globalOptions.workdir}/instructions/$instruction/$instruction.s")
  }

  /** Get a fresh name for a result. */
  def getFreshDiscardedName(prefix: String, instruction: Instruction): File = {
    val resDir = getInstructionDiscardedDir(instruction)
    if (!resDir.exists()) {
      resDir.mkdir()
    }
    var i = 0
    while (true) {
      val file = new File(f"$resDir/$prefix-$i%05d.s")
      if (!file.exists()) {
        return file
      }
      i += 1
    }
    assert(false)
    null
  }
  /** Get a fresh name for a result. */
  def getFreshResultName(instruction: Instruction): File = {
    val resDir = getInstructionResultDir(instruction)
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
  /** Get all result files. */
  def getResultFiles(instruction: Instruction): Seq[File] = {
    val resDir = getInstructionResultDir(instruction)
    if (!resDir.exists()) {
      return Nil
    }
    val res = ListBuffer[File]()
    var i = 0
    while (true) {
      val file = new File(f"$resDir/result-$i%05d.s")
      if (!file.exists()) {
        return res.toList
      }
      res += file
      i += 1
    }
    assert(false)
    null
  }

  def getInstructionResultDir(instruction: Instruction): File = {
    new File(s"${globalOptions.workdir}/instructions/$instruction/results")
  }
  def getInstructionDiscardedDir(instruction: Instruction): File = {
    new File(s"${globalOptions.workdir}/instructions/$instruction/discarded")
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
    IO.writeFile(file, writePretty(meta))
  }

  /** Get the number of pseudo instructions. */
  lazy val getNumPseudoInstr: Int = {
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
  private val PATH_CIRCUITS = "circuits"
  private val PATH_SCORE_CACHE = "score_cache.json"
  private val PATH_GOAL = s"$PATH_INFO/remaining_goal.instrs"
  private val PATH_WORKLIST = s"$PATH_INFO/worklist.instrs"
  private val PATH_SHUTDOWN = s"$PATH_INFO/signal.shutdown"
  private val PATH_PARTIAL_SUCCESS = s"$PATH_INFO/partial_success.instrs"
  private val PATH_SUCCESS = s"$PATH_INFO/success.instrs"
  private val PATH_INITIAL_BASE = s"$PATH_INFO/initial_base.instrs"
  private val PATH_INITIAL_GAOL = s"$PATH_INFO/initial_goal.instrs"
  private val PATH_ALL = s"$PATH_INFO/all.instrs"
  private val PATH_FUNCTIONS = "functions"
  private val PATH_TESTCASES = "testcases.tc"
}
