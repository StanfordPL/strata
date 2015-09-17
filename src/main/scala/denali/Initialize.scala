package denali

import java.io.File

import denali.util.IO

/**
 * Initializing the configuration of a denali run.
 */
object Initialize {
  def run(c: Config, skipIfExists: Boolean = false): Unit = {
    IO.info("starting initialization ...")
    if (c.workdir.exists()) {
      if (skipIfExists) return
      IO.error("Working directory already exists, cannot initialize again.")
    }
    if (!c.workdir.exists()) {
      c.workdir.mkdirs()
    }

    IO.info("producing pseudo functions")
    val functionTemplates = s"${IO.getProjectBase}/resources/function-templates"
    val functionOutput = s"${c.workdir}/functions"
    IO.subcommand(s"scripts/python/create_functions.py $functionTemplates $functionOutput")

    IO.info("initialize configuration using specgen init")
    IO.subcommand(s"stoke/bin/specgen init --workdir ${c.workdir}")

    IO.info("initialization complete")
  }
}
