package denali.tasks

import java.io.File

import denali.data._
import denali.util.ColoredOutput._
import denali.util.IO
import org.apache.commons.io.FileUtils

import scala.sys.ShutdownHookThread

/**
 * Perform an secondary search for a given instruction.
 */
object SecondarySearch {
  def run(task: SecondarySearchTask): SecondarySearchResult = {
    val globalOptions = task.globalOptions
    val state = State(globalOptions)
    val workdir = globalOptions.workdir

    val instr = task.instruction
    val budget = task.budget

    // set up tmp dir
    val tmpDir = new File(s"${state.getTmpDir}/${ThreadContext.self.fileNameSafe}")
    tmpDir.mkdir()
    var hook: Option[ShutdownHookThread] = None
    if (!globalOptions.keepTmpDirs) {
      hook = Some(sys.addShutdownHook {
        try {
          FileUtils.deleteDirectory(tmpDir)
        } catch {
          case _: Throwable =>
        }
      })
    }

    try {
      val meta = state.getMetaOfInstr(instr)
      val base = state.lockedInformation(() => state.getInstructionFile(InstructionFile.Success))
      val baseConfig = new File(s"$tmpDir/base.conf")
      IO.writeFile(baseConfig, "--opc_whitelist \"{ " + base.mkString(" ") + " }\"\n")
      val cmd = Vector(s"${IO.getProjectBase}/stoke/bin/stoke", "search",
        "--config", s"${IO.getProjectBase}/resources/conf-files/search.conf",
        "--config", baseConfig,
        "--target", state.getTargetOfInstr(instr),
        "--def_in", meta.def_in,
        "--live_out", meta.live_out,
        "--functions", s"$workdir/functions",
        "--testcases", s"$workdir/testcases.tc",
        "--machine_output", "search.json",
        "--call_weight", state.getNumPseudoInstr,
        "--timeout_iterations", budget,
        "--non_goal", state.getInstructionResultDir(instr),
        "--cost", "correctness + nongoal",
        "--correctness", "(correctness + nongoal) == 0")
      if (globalOptions.verbose) {
        IO.runPrint(cmd, workingDirectory = tmpDir)
      } else {
        IO.runQuiet(cmd, workingDirectory = tmpDir)
      }
      val result = Stoke.readStokeSearchOutput(new File(s"$tmpDir/search.json"))
      result match {
        case None =>
          state.appendLog(LogError(s"no result for initial search of $instr"))
          IO.info("stoke failed".red)
          SecondarySearchError(task)
        case Some(res) =>
          val meta = state.getMetaOfInstr(instr)

          // update meta
          val more = SecondarySearchMeta(if (res.success && res.verified) 1 else 0,
            budget, res.statistics.total_iterations, base.length)
          val newMeta = meta.copy(secondary_searches = meta.secondary_searches ++ Vector(more))
          state.writeMetaOfInstr(instr, newMeta)

          if (res.success && res.verified) {
            // copy result file
            val resFile = new File(s"$tmpDir/result.s")
            IO.copyFile(resFile, state.getFreshResultName(instr))

            SecondarySearchSuccess(task)
          } else {
            SecondarySearchTimeout(task)
          }
      }
    } finally {
      // tear down tmp dir
      if (!globalOptions.keepTmpDirs) {
        FileUtils.deleteDirectory(tmpDir)
        hook match {
          case None =>
          case Some(h) => h.remove()
        }
      }
    }
  }
}
