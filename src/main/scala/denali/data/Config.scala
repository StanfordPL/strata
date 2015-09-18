package denali.data

import java.io.{FileWriter, File}
import java.util.Calendar
import denali.GlobalOptions
import scala.io.Source
import denali.util.{IO, Locking}

/**
 * Code to interact with the configuration of a denali run.
 */
class Config(cmdOptions: GlobalOptions) {

  /** Get all the goal instructions. */
  def getGoal: Seq[Instruction] = {
    val file = Source.fromFile(s"${cmdOptions.workdir}/config/goal.txt")
    val res = for (goal <- file.getLines()) yield {
      new Instruction(goal.stripLineEnd, cmdOptions)
    }
    file.close()
    res.toSeq
  }

  /** Has the configuration already been set up? */
  def exists: Boolean = {
    new File(s"${cmdOptions.workdir}/config/").exists
  }

  /** Add an entry to the global log file. */
  def appendLog(msg: String): Unit = {
    val file = new File(s"${cmdOptions.workdir}/config/log.txt")
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
}

object Config {
  def apply(cmdOptions: GlobalOptions) = new Config(cmdOptions)
}
