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

    // set up tmp dir
    val tmpDir = Files.createTempDirectory("stoke").toFile

    try {
      val meta = state.getMetaOfInstr(instr)
      val cmd = s"""stoke/bin/stoke search
                   |--config resources/conf-files/search.conf
                   |--target ${state.getTargetOfInstr(instr)}
                   |--def_in ${meta.def_in}
                   |--live_out ${meta.live_out}
          | """.stripMargin.replaceAll("\n", " ").replaceAll(" +", " ")
      println(cmd)
      IO.subcommand(cmd)
    } finally {
      // tear down tmp dir
      tmpDir.delete()
    }
  }
}
