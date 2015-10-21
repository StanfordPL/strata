package denali.tasks

import java.io.File

import denali.data._
import denali.util.{TimingKind, TimingBuilder, IO}
import denali.util.ColoredOutput._

import scala.sys.ShutdownHookThread

/**
 * Perform an initial search for a given instruction.
 */
object InitialSearch {
  def run(task: InitialSearchTask): InitialSearchResult = {
    val timing = TimingBuilder()

    val globalOptions = task.globalOptions
    val state = State(globalOptions)
    val workdir = globalOptions.workdir

    val instr = task.instruction
    val budget = task.budget

    // set up tmp dir
    val tmpDir = new File(s"${state.getTmpDir}/${ThreadContext.self.fileNameSafe}")
    tmpDir.mkdir()

    try {
      val meta = state.getMetaOfInstr(instr)
      val testcases = new File(s"$tmpDir/testcases.tc")
      val base = state.lockedInformation(() => {
        // copy the tests to the local directory
        IO.copyFile(state.getTestcasePath, testcases)

        // get the base instructions
        state.getInstructionFile(InstructionFile.Success)
      })
      val baseConfig = new File(s"$tmpDir/base.conf")
      IO.writeFile(baseConfig, "--opc_whitelist \"{ " + base.mkString(" ") + " }\"\n")
      timing.timeOperation(TimingKind.Search)({
        val cmd = Vector(s"${IO.getProjectBase}/stoke/bin/stoke", "search",
          "--config", s"${IO.getProjectBase}/resources/conf-files/search.conf",
          "--config", baseConfig,
          "--target", state.getTargetOfInstr(instr),
          "--def_in", meta.def_in,
          "--live_out", meta.live_out,
          "--functions", s"$workdir/functions",
          "--testcases", testcases,
          "--machine_output", "search.json",
          "--call_weight", state.getNumPseudoInstr,
          "--timeout_iterations", budget,
          "--cost", "correctness")
        if (globalOptions.verbose) {
          IO.runPrint(cmd, workingDirectory = tmpDir)
        } else {
          IO.runQuiet(cmd, workingDirectory = tmpDir)
        }
      })
      val result = Stoke.readStokeSearchOutput(new File(s"$tmpDir/search.json"))
      result match {
        case None =>
          state.appendLog(LogError(s"no result for initial search of $instr"))
          IO.info("stoke failed".red)
          InitialSearchError(task, timing.result)
        case Some(res) =>
          val meta = state.getMetaOfInstr(instr)
          if (res.success && res.verified) {
            // copy result file
            val resFile = new File(s"$tmpDir/result.s")
            IO.copyFile(resFile, state.getFreshResultName(instr))

            // update meta
            val more = InitialSearchMeta(success = true, budget, res.statistics.total_iterations, base.length)
            val newMeta = meta.copy(initial_searches = meta.initial_searches ++ Vector(more))
            state.writeMetaOfInstr(instr, newMeta)

            InitialSearchSuccess(task, timing.result)
          } else {
            // update meta
            val more = InitialSearchMeta(success = false, budget, res.statistics.total_iterations, base.length)
            val newMeta = meta.copy(initial_searches = meta.initial_searches ++ Vector(more))
            state.writeMetaOfInstr(instr, newMeta)

            InitialSearchTimeout(task, timing.result)
          }
      }
    } finally {
      // tear down tmp dir
      if (!globalOptions.keepTmpDirs) {
        IO.deleteDirectory(tmpDir)
      }
    }
  }
}
