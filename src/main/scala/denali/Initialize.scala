package denali

import java.io.File

import denali.util.IO
import org.apache.commons.io.FileUtils

/**
 * Initializing the configuration of a denali run.
 */
object Initialize {
  def run(cmdOptions: CmdOptions, skipIfExists: Boolean = false): Unit = {

    // TODO: remove this debug code:
    if (cmdOptions.workdir.exists()) {
      FileUtils.deleteDirectory(cmdOptions.workdir)
    }

    IO.info("starting initialization ...")
    if (cmdOptions.workdir.exists()) {
      if (skipIfExists) return
      IO.error("Working directory already exists, cannot initialize again.")
    }
    if (!cmdOptions.workdir.exists()) {
      cmdOptions.workdir.mkdirs()
    }

    IO.info("producing pseudo functions ...")
    val functionTemplates = s"${IO.getProjectBase}/resources/function-templates"
    val functionOutput = s"${cmdOptions.workdir}/functions"
    IO.subcommand(s"scripts/python/create_functions.py $functionTemplates $functionOutput")

    IO.info("initialize configuration using specgen init ...")
    IO.subcommand(s"stoke/bin/specgen init --workdir ${cmdOptions.workdir}")

    IO.info("collecting basic information for all instructions ...")
    val config = Config(cmdOptions)
    config.getGoal.par foreach { goal =>
      IO.subcommand(s"stoke/bin/specgen setup --workdir ${cmdOptions.workdir} --opc $goal")
    }

    IO.info("initialization complete")
  }
}
