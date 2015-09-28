package denali

import java.util.concurrent.{Callable, Executors, ExecutorCompletionService}

import denali.data.{State, Instruction}
import denali.tasks._

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
    val threadPool = new ExecutorCompletionService[TaskResult](Executors.newFixedThreadPool(nThreads))
    var tasksRunning = 0

    /** start a new task */
    def startNewTask(task: Task): Unit = {
      val callable: Callable[TaskResult] = new Callable[TaskResult] {
        def call(): TaskResult = {
          val res: TaskResult = task match {
            case InitialSearchStep(instruction) =>
              // TODO right budget
              InitialSearch.run(InitialSearchOptions(globalOptions, instruction, 300000))
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
        taskRes match {
          case InitialSearchSuccess() =>
            println("initial search success")
          case InitialSearchTimeout() =>
            println("initial search timeout")
        }
      } catch {
        case _: Throwable =>
          // TODO error handling
          println("ERROR: failure")
      }
      tasksRunning -= 1

      // start new tasks
      startNewTasks(nThreads - tasksRunning)
    }
  }

  /** Select what next step should be done, and marks that task as being under construction. */
  def selectNextTask(): Option[Task] = {
    state.lockInformation()

    try {
      val goal = state.getGoalInstrs()
      val partial_succ = state.getPartialSuccessInstrs()

      // first deal with partial successes (so that we can put them into success as soon as possible)
      if (partial_succ.nonEmpty) {
        // TODO
        return Some(null)
      }

      // then try an intial search
      if (goal.nonEmpty) {
        val instr = goal(Random.nextInt(goal.size))
        state.moveToWorklist(instr)
        return Some(InitialSearchStep(instr))
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
