package denali

import java.util.concurrent.{Callable, Executors, ExecutorCompletionService}

import denali.data.{InstructionFile, State, Instruction}
import denali.tasks._
import denali.util.IO
import denali.util.ColoredOutput._

import scala.util.Random

/**
 * Driver for a full run of denali.  Takes care of deciding what to run next.
 */
class Driver(val globalOptions: GlobalOptions) {

  val state = State(globalOptions)

  def run(args: Array[String]): Unit = {
    // initialize
    Initialize.run(args, InitOptions(globalOptions))

    // TODO better value
    val nThreads = 2

    // our pool of threads to do all the computation
    val executor = Executors.newFixedThreadPool(nThreads)
    val threadPool = new ExecutorCompletionService[TaskResult](executor)
    var tasksRunning = 0

    /** start a new task */
    def startNewTask(task: Task): Unit = {
      IO.info(s"submitting task for ${task.instruction}")
      val callable: Callable[TaskResult] = new Callable[TaskResult] {
        def call(): TaskResult = {
          val res: TaskResult = task match {
            case t: InitialSearchTask =>
              InitialSearch.run(t)
          }
          res
        }
      }
      tasksRunning += 1
      threadPool.submit(callable)
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
      val task = threadPool.take()
      try {
        val taskRes = task.get()
        // TODO handle result
        handleTaskResult(taskRes)
      } catch {
        case t: Throwable =>
          // TODO error handling
          IO.info(s"ERROR: failure: ${t.getMessage}\n${t.getStackTrace.mkString("\n")}".red)
      }
      tasksRunning -= 1

      // start new tasks
      startNewTasks(nThreads - tasksRunning)
    }

    executor.shutdown()
    IO.info("Finished all tasks")
  }

  /** Handle the result of a task. */
  def handleTaskResult(taskRes: TaskResult): Unit = {
    state.lockInformation()

    try {
      state.removeInstructionToFile(taskRes.instruction, InstructionFile.Worklist)
      taskRes match {
        case InitialSearchSuccess(task) =>
          // TODO: actually this is only partial success
          state.addInstructionToFile(taskRes.instruction, InstructionFile.Success)
          state.removeInstructionToFile(taskRes.instruction, InstructionFile.RemainingGoal)
          println("initial search success")
        case InitialSearchTimeout(task) =>
          println("initial search timeout")
      }
    } finally {
      state.unlockInformation()
    }
  }

  /** Select what next step should be done, and puts the task into the worklist. */
  def selectNextTask(): Option[Task] = {
    state.lockInformation()

    try {
      val goal = state.getInstructionFile(InstructionFile.RemainingGoal)
      val partial_succ = state.getInstructionFile(InstructionFile.PartialSuccess)

      // first deal with partial successes (so that we can put them into success as soon as possible)
      if (partial_succ.nonEmpty) {
        // TODO secondary search
        return Some(null)
      }

      // then try an intial search
      if (goal.nonEmpty) {
        val instr = goal(Random.nextInt(goal.size))
        state.addInstructionToFile(instr, InstructionFile.Worklist)
        // TODO correct budget
        return Some(InitialSearchTask(state.globalOptions, instr, 300000))
      }

      // cannot do anything for now
      None
    } finally {
      state.unlockInformation()
    }
  }
}

/**
 * Companion object
 */
object Driver {
  def apply(globalOptions: GlobalOptions) = new Driver(globalOptions)
}
