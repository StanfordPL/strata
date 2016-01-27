package strata

import java.io.File

import strata.data._
import strata.util.{TimingBuilder, IO}

/**
 * Initializing the configuration of a strata run.
 */
object Initialize {
  def run(args: Array[String], options: InitOptions, skipIfExists: Boolean = false): Unit = {

    val timing = TimingBuilder()

    val workdir = options.globalOptions.workdir

    // TODO: remove this debug code:
    if (workdir.exists()) {
      IO.deleteDirectory(workdir)
    }

    IO.info("starting initialization ...")
    if (workdir.exists()) {
      if (skipIfExists) return
      IO.error("Working directory already exists, cannot initialize again.")
    }
    if (!workdir.exists()) {
      workdir.mkdirs()
    }

    val state = State(options.globalOptions)
    state.getInfoPath.mkdirs()
    state.getLogDir.mkdirs()
    state.getLogBinDir.mkdirs()
    state.appendLog(LogEntryPoint(args))

    IO.info("producing pseudo functions ...")
    val functionTemplates = s"${IO.getProjectBase}/resources/function-templates"
    val functionOutput = s"$workdir/functions"
    IO.safeSubcommand(Vector("scripts/python/create_functions.py", functionTemplates, functionOutput))

    IO.info("initialize configuration using specgen init ...")
    val initArgs = if (options.imm_instructions) {
      Vector("--only_imm", "--imm_count", "256")
    } else if (options.mm_instructions) {
      Vector("--only_mm")
    } else {
      Nil
    }
    IO.safeSubcommand(Vector("stoke/bin/specgen", "init", "--workdir", workdir) ++ initArgs)

    IO.info("generate random testcases ...")
    IO.safeSubcommand(Vector("stoke/bin/stoke", "testcase", "--out", state.getTestcasePath,
      "--target", "resources/empty.s", "--max_testcases", 1024,
      "--def_in", "{ }", "--live_out", "{ }"))
    IO.safeSubcommand(Vector("stoke/bin/specgen", "augment_tests",
      "--testcases", state.getTestcasePath,
      "--out", state.getTestcasePath
    ))

    // copy imm8 base set
    if (options.imm_instructions || options.mm_instructions) {
      IO.copyDir(new File("resources/imm8_baseset"), state.getCircuitDir)
    } else {
      state.getCircuitDir.mkdirs()
    }

    IO.info("collecting basic information for all instructions ...")
    val config = State(options.globalOptions)
    config.getInstructionFile(InstructionFile.RemainingGoal).par foreach { goal =>
      IO.safeSubcommand(Vector("stoke/bin/specgen", "setup", "--workdir", workdir, "--opc", goal), noStatus = true)
    }

    state.appendLog(LogInitEnd(timing.result))
    IO.info("initialization complete")
  }
}
