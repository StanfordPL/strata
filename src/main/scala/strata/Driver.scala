package strata

import java.io.File
import java.util.concurrent._

import strata.data._
import strata.tasks._
import strata.util.{TimingKind, IO}
import strata.util.ColoredOutput._
import org.joda.time.DateTime

import scala.util.Random

/**
 * Driver for a full run of strata.  Takes care of deciding what to run next.
 */
class Driver(val globalOptions: GlobalOptions) {

  val state = State(globalOptions)

  def run(args: Array[String], continue: Boolean = false): Unit = {
    // initialize
    if (!continue) {
      Initialize.run(args, InitOptions(globalOptions))
    } else {
      if (!state.exists) IO.error("workdir does not exist, cannot continue")
      state.appendLog(LogEntryPoint(args))
    }

    // TODO better value
    val nThreads = Runtime.getRuntime.availableProcessors() * 3 / 4
    IO.info(s"Running with $nThreads threads")

    // our pool of threads to do all the computation
    val executor = Executors.newFixedThreadPool(nThreads)
    val threadPool = new ExecutorCompletionService[TaskResult](executor)
    var tasksRunning = 0
    val taskMap = collection.mutable.HashMap[Future[TaskResult], Task]()

    /** start a new task */
    def startNewTask(task: Task): Unit = {
      val callable: Callable[TaskResult] = new Callable[TaskResult] {
        def call(): TaskResult = {
          runTask(task)
        }
      }
      tasksRunning += 1
      val future = threadPool.submit(callable)
      taskMap.put(future, task)
    }

    /** Start up to n new tasks. */
    def startNewTasks(n: Int): Unit = {
      for (i <- 1 to n) {
        selectNextTask() match {
          case None =>
          case Some(t) => startNewTask(t)
        }
      }
    }

    // initial set of tasks
    startNewTasks(nThreads)

    // main loop
    while (tasksRunning > 0) {
      val future = threadPool.take()
      finishTask(taskMap(future), future)
      taskMap.remove(future)
      tasksRunning -= 1

      // start new tasks
      startNewTasks(nThreads - tasksRunning)
    }

    executor.shutdown()
    IO.info("Finished all tasks")
  }

  /** Execute a task. */
  private def runTask(task: Task): TaskResult = {
    task.runnerContext = ThreadContext.self
    task match {
      case t: InitialSearchTask =>
        InitialSearch.run(t)
      case t: SecondarySearchTask =>
        SecondarySearch.run(t)
    }
  }

  /** Run a task asynchronously. */
  private var poolForOthers: ExecutorService = null
  def runTaskAsync(task: Task): Future[TaskResult] = {
    poolForOthers = Executors.newFixedThreadPool(1)
    poolForOthers.submit(new Callable[TaskResult] {
      override def call(): TaskResult = runTask(task)
    })
  }
  def endAsync(): Unit = {
    poolForOthers.shutdown()
  }

  /** Finish a task, correctly handling errors and taks results. */
  def finishTask(task: Task, future: Future[TaskResult]): Unit = {
    try {
      val taskRes = future.get()
      val pseudoTimeEnd = handleTaskResult(taskRes)
      state.appendLog(LogTaskEnd(task, Some(taskRes), pseudoTimeEnd, DateTime.now, task.runnerContext))
    } catch {
      case t: Throwable =>
        state.appendLog(LogTaskEnd(task, None, -1, DateTime.now, task.runnerContext))
        state.appendLog(LogError(s"exception in task: ${t.getMessage}\n${t.getCause.getStackTrace.mkString("\n")}"))
        IO.info(s"ERROR: failure: ${t.getMessage}\n${t.getCause.getStackTrace.mkString("\n")}".red)
        state.lockedInformation(() => {
          state.removeInstructionToFile(task.instruction, InstructionFile.Worklist)
        })
    }
  }

  /** Handle the result of a task. */
  private def handleTaskResult(taskRes: TaskResult): Int = {
    val task = taskRes.task
    val instr = taskRes.instruction
    def moveProgramToCircuitDir(meta: InstructionMeta, n: Int): Unit = {
      // copy a file to the circuits directory
      if (meta.equivalent_programs.isEmpty) {
        val msg = s"Found $n programs, but none of them proved equivalent"
        state.appendLog(LogError(msg))
        IO.info(msg.red)
        IO.copyFile(state.getResultFiles(instr).head, new File(s"${state.getCircuitDir}/$instr.s"))
      } else {
        IO.copyFile(meta.getEquivProgram(instr, state), new File(s"${state.getCircuitDir}/$instr.s"))
      }
    }
    state.lockedInformation(() => {
      state.removeInstructionToFile(instr, InstructionFile.Worklist)
      taskRes match {
        case _: InitialSearchSuccess =>
          state.removeInstructionToFile(instr, InstructionFile.RemainingGoal)
          state.addInstructionToFile(instr, InstructionFile.PartialSuccess)
          IO.info(s"IS success for ${task.instruction}")
        case ist: InitialSearchTimeout =>
          IO.info(s"IS timeout for ${task.instruction} after ${ist.task.budget} iters / ${IO.formatNanos(ist.timing.total)}")
        case _: InitialSearchError =>
        case _: SecondarySearchError =>
        case _: SecondarySearchSuccess | _: SecondarySearchTimeout =>
          val meta = state.getMetaOfInstr(task.instruction)
          val n = meta.secondary_searches.map(s => s.n_found).sum + 1 // +1 for initial search
          IO.info(s"SS success #$n for ${task.instruction}")
          // stop after we found enough
          if (n >= 30 || taskRes.isInstanceOf[SecondarySearchTimeout]) {
            moveProgramToCircuitDir(meta, n)
            state.removeInstructionToFile(instr, InstructionFile.PartialSuccess)
            state.addInstructionToFile(instr, InstructionFile.Success)
          }
        case _: SecondarySearchTimeout =>
          val meta = state.getMetaOfInstr(task.instruction)
          val n = meta.secondary_searches.map(s => s.n_found).sum + 1 // +1 for initial search
          IO.info(s"SS timeout for ${task.instruction} after ${IO.formatNanos(taskRes.timing.total)}")
          // stop if we tried 5 times and didn't succeed
          if (meta.secondary_searches.length >= 5) {
            moveProgramToCircuitDir(meta, n)
            state.removeInstructionToFile(instr, InstructionFile.PartialSuccess)
            state.addInstructionToFile(instr, InstructionFile.Success)
          }
      }
      state.getPseudoTime
    })
  }

  /** Compute the budget for the initial search. */
  def initialSearchBudget(instr: Instruction): Long = {
    val pnow = state.getPseudoTime
    val meta = state.getMetaOfInstr(instr)
    val default = 200000
    var res: Double = default
    for (initalSearch <- meta.initial_searches) {
      res += 1.0 / Math.pow(1.5, pnow - initalSearch.start_ptime) * initalSearch.iterations
    }
    Math.min(res.toLong, 10000000)
  }

  /** Compute the budget for the secondary search. */
  def secondarySearchBudget(instr: Instruction): Long = {
    50000000
  }

  /** Select what next step should be done, and puts the task into the worklist. */
  def selectNextTask(instruction: Option[Instruction] = None): Option[Task] = {
    def mkInitialSearch(instr: Instruction, pseudoTime: Int): Option[Task] = {
      val budget = initialSearchBudget(instr)
      state.addInstructionToFile(instr, InstructionFile.Worklist)
      Some(InitialSearchTask(state.globalOptions, instr, budget, pseudoTime))
    }

    def mkSecondarySearch(instr: Instruction, pseudoTime: Int): Option[Task] = {
      val budget = secondarySearchBudget(instr)
      state.addInstructionToFile(instr, InstructionFile.Worklist)
      Some(SecondarySearchTask(state.globalOptions, instr, budget, pseudoTime))
    }

    state.lockedInformation(() => {

      // should we stop?
      if (state.signalShutdownReceived) {
        return None
      }

      val pseudoTime = state.getPseudoTime
      val goal = state.getInstructionFile(InstructionFile.RemainingGoal)
      val partialSucc = state.getInstructionFile(InstructionFile.PartialSuccess)

      if (instruction.isDefined) {
        val instr = instruction.get
        if (goal.contains(instr)) {
          return mkInitialSearch(instr, pseudoTime)
        } else if (partialSucc.contains(instr)) {
          return mkSecondarySearch(instr, pseudoTime)
        } else {
          return None
        }
      }

      // first deal with partial successes (so that we can put them into success as soon as possible)
      if (partialSucc.nonEmpty) {
        val instr = partialSucc(Random.nextInt(partialSucc.size))
        return mkSecondarySearch(instr, pseudoTime)
      }

      // then try an intial search
      if (goal.nonEmpty) {
        val instr = goal(Random.nextInt(goal.size))
        return mkInitialSearch(instr, pseudoTime)
      }

      // cannot do anything for now
      None
    })
  }
}

/**
 * Companion object
 */
object Driver {
  def apply(globalOptions: GlobalOptions) = new Driver(globalOptions)
}
