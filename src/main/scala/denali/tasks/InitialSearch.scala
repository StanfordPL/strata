package denali.tasks

import java.io.File

import denali.data.{InitialSearchMeta, InstructionFile, State, Stoke}
import denali.util.IO
import org.apache.commons.io.FileUtils
import denali.util.ColoredOutput._

/**
 * Perform an initial search for a given instruction.
 */
object InitialSearch {
  def run(task: InitialSearchTask): InitialSearchResult = {
    val globalOptions = task.globalOptions
    val state = State(globalOptions)
    val workdir = globalOptions.workdir

    val instr = task.instruction
    val budget = task.budget

    state.appendLog(s"start initial_search $instr")

    // set up tmp dir
    val tmpDir = new File(s"${state.getTmpDir}/${IO.getExecContextId}")
    tmpDir.mkdir()
    sys.addShutdownHook {
      try {
        FileUtils.deleteDirectory(tmpDir)
      } catch {
        case _: Throwable =>
      }
    }

    try {
      val meta = state.getMetaOfInstr(instr)
      val base = state.lockedInformation (() => state.getInstructionFile(InstructionFile.Success))
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
        "--cost", "correctness")
      if (globalOptions.verbose) {
        IO.runPrint(cmd, workingDirectory = tmpDir)
      } else {
        IO.runQuiet(cmd, workingDirectory = tmpDir)
      }
      val result = Stoke.readStokeSearchOutput(new File(s"$tmpDir/search.json"))
      result match {
        case None =>
          state.appendLogUnexpected(s"no result for initial search of $instr")
          IO.info("stoke failed".red)
          InitialSearchTimeout(task)
        case Some(res) =>
          val meta = state.getMetaOfInstr(instr)
          if (res.success && res.verified) {
            // initial search succeeded
            state.appendLog(s"initial search succeeded for $instr")

            // update meta
            val more = InitialSearchMeta(success = true, budget, res.statistics.total_iterations, base.length)
            val newMeta = meta.copy(initial_searches = meta.initial_searches ++ Vector(more))
            state.writeMetaOfInstr(instr, newMeta)

            InitialSearchSuccess(task)
          } else {
            // search failed, update statistics
            state.appendLog("initial search failed for $instr")

            // update meta
            val more = InitialSearchMeta(success = false, budget, res.statistics.total_iterations, base.length)
            val newMeta = meta.copy(initial_searches = meta.initial_searches ++ Vector(more))
            state.writeMetaOfInstr(instr, newMeta)

            InitialSearchTimeout(task)
          }
      }
    } finally {
      // tear down tmp dir
      FileUtils.deleteDirectory(tmpDir)

      state.appendLog(s"end initial_search $instr")
    }
  }
}
