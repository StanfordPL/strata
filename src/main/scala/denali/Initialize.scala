package denali

import java.io.File

import denali.data.{InstructionFile, State}
import denali.util.IO
import org.apache.commons.io.FileUtils

/**
 * Initializing the configuration of a denali run.
 */
object Initialize {
  def run(args: Array[String], options: InitOptions, skipIfExists: Boolean = false): Unit = {

    val workdir = options.globalOptions.workdir

    // TODO: remove this debug code:
    if (workdir.exists()) {
      FileUtils.deleteDirectory(workdir)
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
    state.getStateDir.mkdirs()
    state.appendLog(s"Entry point: denali ${args.mkString(" ")}")
    state.appendLog(s"start initialize")

    IO.info("producing pseudo functions ...")
    val functionTemplates = s"${IO.getProjectBase}/resources/function-templates"
    val functionOutput = s"$workdir/functions"
    IO.safeSubcommand(Vector("scripts/python/create_functions.py", functionTemplates, functionOutput))

    IO.info("initialize configuration using specgen init ...")
    IO.safeSubcommand(Vector("stoke/bin/specgen", "init", "--workdir", workdir))

    IO.info("generate random testcases ...")
    IO.safeSubcommand(Vector("stoke/bin/stoke", "testcase", "--out", state.getTestcasePath,
      "--target", "resources/empty.s", "--max_testcases", 1024,
      "--def_in", "{ }", "--live_out", "{ }"))

    IO.info("collecting basic information for all instructions ...")
    val config = State(options.globalOptions)
    config.getInstructionFile(InstructionFile.RemainingGoal).par foreach { goal =>
      IO.safeSubcommand(Vector("stoke/bin/specgen", "setup", "--workdir", workdir, "--opc", goal))
    }

    state.getTmpDir.mkdirs()

    state.appendLog(s"end initialize")

    IO.info("initialization complete")
  }
}
