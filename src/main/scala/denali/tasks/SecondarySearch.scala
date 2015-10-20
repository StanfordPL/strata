package denali.tasks

import java.io.File

import denali.data._
import denali.util.ColoredOutput._
import denali.util.{Timing, TimingKind, TimingBuilder, IO}
import org.apache.commons.io.FileUtils

import scala.sys.ShutdownHookThread

/**
 * Perform an secondary search for a given instruction.
 */
object SecondarySearch {
  def run(task: SecondarySearchTask): SecondarySearchResult = {

    val timing = TimingBuilder()

    val globalOptions = task.globalOptions
    val state = State(globalOptions)
    val workdir = globalOptions.workdir

    val instr = task.instruction
    val budget = task.budget

    // set up tmp dir
    val tmpDir = new File(s"${state.getTmpDir}/${ThreadContext.self.fileNameSafe}")
    tmpDir.mkdir()
    var hook: Option[ShutdownHookThread] = None
    if (!globalOptions.keepTmpDirs) {
      hook = Some(sys.addShutdownHook {
        try {
          FileUtils.deleteDirectory(tmpDir)
        } catch {
          case _: Throwable =>
        }
      })
    }

    /**
     * Take two programs and compare them formally.  Returns a verification result only if there was no error.
     */
    def stokeVerify(meta: InstructionMeta, a: File, b: File, useFormal: Boolean): Option[StokeVerifyOutput] = {
      val (_, res) = timing.timeOperation(TimingKind.Verification)({
        val cmd = Vector("timeout", "10s",
          s"${IO.getProjectBase}/stoke/bin/stoke", "debug", "verify",
          "--config", s"${IO.getProjectBase}/resources/conf-files/formal.conf",
          "--target", a,
          "--rewrite", b,
          "--strategy", if (useFormal) "bounded" else "hold_out",
          "--def_in", meta.def_in_formal,
          "--live_out", meta.live_out_formal,
          "--strata_path", state.getCircuitDir,
          "--functions", s"$workdir/functions",
          "--machine_output", "verify.json")
        if (globalOptions.verbose) {
          IO.runPrint(cmd, workingDirectory = tmpDir)
        } else {
          IO.runQuiet(cmd, workingDirectory = tmpDir)
        }
      })

      if (res == 124) {
        // a timeout happened
        val verifyRes = StokeVerifyOutput.makeTimeout
        state.appendLog(LogVerifyResult(instr, verifyRes, IO.contentHash(a), IO.contentHash(a)))
        Some(verifyRes)
      } else {
        Stoke.readStokeVerifyOutput(new File(s"$tmpDir/verify.json")) match {
          case None =>
            state.appendLog(LogError(s"no result for stoke verify of $instr"))
            IO.info("stoke verify failed to produce an output".red)
            None
          case Some(verifyRes) if verifyRes.hasError =>
            val message = s"stoke verify errored with ${verifyRes.error} for $instr"
            state.appendLog(LogError(message))
            state.appendLog(LogVerifyResult(instr, verifyRes, IO.contentHash(a), IO.contentHash(a)))
            IO.info(message.red)
            None
          case Some(verifyRes) =>
            state.appendLog(LogVerifyResult(instr, verifyRes, IO.contentHash(a), IO.contentHash(a)))
            Some(verifyRes)
        }
      }
    }

    try {
      val meta = state.getMetaOfInstr(instr)
      val base = state.lockedInformation(() => state.getInstructionFile(InstructionFile.Success))
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
          "--testcases", s"$workdir/testcases.tc",
          "--machine_output", "search.json",
          "--call_weight", state.getNumPseudoInstr,
          "--timeout_iterations", budget,
          "--non_goal", state.getInstructionResultDir(instr),
          "--cost", "correctness + nongoal",
          "--correctness", "(correctness + nongoal) == 0")
        if (globalOptions.verbose) {
          IO.runPrint(cmd, workingDirectory = tmpDir)
        } else {
          IO.runQuiet(cmd, workingDirectory = tmpDir)
        }
      })
      Stoke.readStokeSearchOutput(new File(s"$tmpDir/search.json")) match {
        case None =>
          state.appendLog(LogError(s"no result for secondary search of $instr"))
          IO.info("stoke failed".red)
          SecondarySearchError(task, timing.result)
        case Some(res) =>
          val meta = state.getMetaOfInstr(instr)

          // update meta
          val more = SecondarySearchMeta(if (res.success && res.verified) 1 else 0,
            budget, res.statistics.total_iterations, base.length)
          val newMeta = meta.copy(secondary_searches = meta.secondary_searches ++ Vector(more))
          state.writeMetaOfInstr(instr, newMeta)

          if (res.success && res.verified) {

            val resFile = new File(s"$tmpDir/result.s")
            val newResultFileName = state.getFreshResultName(instr)

            for (previousRes <- state.getResultFiles(instr)) {
              stokeVerify(meta, resFile, previousRes, useFormal = true) match {
                case None =>
                case Some(verifyRes) =>

              }
            }

            SecondarySearchSuccess(task, timing.result)
          } else {
            SecondarySearchTimeout(task, timing.result)
          }
      }
    } finally {
      // tear down tmp dir
      if (!globalOptions.keepTmpDirs) {
        FileUtils.deleteDirectory(tmpDir)
        hook match {
          case None =>
          case Some(h) => h.remove()
        }
      }
    }
  }
}
