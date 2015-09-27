package denali

import java.io.File
import java.nio.file.Files

import denali.data.{Stoke, State, Instruction}
import denali.util.IO

import scala.sys.process.{Process, ProcessLogger}

/**
 * Perform an initial search for a given instruction.
 */
object InitialSearch {
  def run(options: InitialSearchOptions): Unit = {
    val state = State(options.globalOptions)
    val workdir = options.globalOptions.workdir

    // TODO: fix this
    val instr = state.mkInstruction("andq_r64_r64").get

    // TODO: better values
    val budget = 200000

    state.appendLog(s"start initial_search $instr")

    // set up tmp dir
    val tmpDir = new File(s"${state.getTmpDir}/${IO.getExecContextId}")

    try {
      val meta = state.getMetaOfInstr(instr)
      val cmd = Vector(s"${IO.getProjectBase}/stoke/bin/stoke", "search",
        "--config", s"${IO.getProjectBase}/resources/conf-files/search.conf",
        "--target", state.getTargetOfInstr(instr),
        "--def_in", meta.def_in,
        "--live_out", meta.live_out,
        "--functions", s"$workdir/functions",
        "--testcases", s"$workdir/testcases.tc",
        "--machine_output", "search.json",
        "--call_weight", state.getNumPseudoInstr,
        "--timeout_iterations", budget,
        "--cost", "correctness")
      IO.runQuiet(cmd, workingDirectory = tmpDir)
      val result = Stoke.readStokeSearchOutput(new File(s"$tmpDir/search.json"))
      result match {
        case None =>
          state.appendLogUnexpected(s"no result for initial search of $instr")
        case Some(res) =>
          if (res.success && res.verified) {
            // initial search succeeded
            state.appendLog(s"initial search succeeded for $instr")
          } else {
            // search failed, update statistics
            state.appendLog("initial search failed for $instr")
          }
      }
    } finally {
      // tear down tmp dir
      tmpDir.delete()

      state.appendLog(s"end initial_search $instr")
    }
  }
}
