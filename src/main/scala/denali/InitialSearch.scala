package denali

import java.nio.file.Files

import denali.data.{State, Instruction}
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

    // set up tmp dir
    val tmpDir = Files.createTempDirectory("stoke").toFile

    try {
      val meta = state.getMetaOfInstr(instr)
      val cmd = Vector("stoke/bin/stoke", "search",
        "--config", "resources/conf-files/search.conf",
        "--target", state.getTargetOfInstr(instr),
        "--def_in", meta.def_in,
        "--live_out", meta.live_out,
        "--functions", s"$workdir/functions",
        "--call_weight",
        state.getNumPseudoInstr,
        "--timeout_iterations", budget,
        "--cost", "correctness")
      println(cmd.mkString(" "))
      IO.subcommand(cmd)
    } finally {
      // tear down tmp dir
      tmpDir.delete()
    }
  }
}
