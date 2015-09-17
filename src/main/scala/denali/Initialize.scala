package denali

import java.io.File

import denali.util.IO

/**
 * Initializing the configuration of a denali run.
 */
object Initialize {
  def run(c: Config, skipIfExists: Boolean = false): Unit = {
    if (c.workdir.exists()) {
      if (skipIfExists) return
      IO.error("Working directory already exists, cannot initialize again.")
    }
    if (!c.workdir.exists()) {
      c.workdir.mkdirs()
    }
    val functionTemplates = s"${IO.getProjectBase}/resources/function-templates"
    val functionOutput = s"${c.workdir}/functions"
    println(IO.run(s"scripts/python/create_functions.py $functionTemplates $functionOutput")._1)
    //println(IO.run(s"stoke/bin/specgen init --workdir ${c.workdir}")._1)
  }
}
