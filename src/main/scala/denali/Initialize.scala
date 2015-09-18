package denali

import java.io.File

import denali.data.Config
import denali.util.IO
import org.apache.commons.io.FileUtils

/**
 * Initializing the configuration of a denali run.
 */
object Initialize {
  def run(options: InitOptions, skipIfExists: Boolean = false): Unit = {

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

    IO.info("producing pseudo functions ...")
    val functionTemplates = s"${IO.getProjectBase}/resources/function-templates"
    val functionOutput = s"$workdir/functions"
    IO.subcommand(s"scripts/python/create_functions.py $functionTemplates $functionOutput")

    IO.info("initialize configuration using specgen init ...")
    IO.subcommand(s"stoke/bin/specgen init --workdir $workdir")

    IO.info("collecting basic information for all instructions ...")
    val config = Config(options.globalOptions)
    config.getGoal.par foreach { goal =>
      IO.subcommand(s"stoke/bin/specgen setup --workdir $workdir --opc $goal")
    }

    IO.info("initialization complete")
  }
}
