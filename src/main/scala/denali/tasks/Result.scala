package denali.tasks


/**
 * The result of a task in denali
 */
sealed trait TaskResult {
  def task: Task
  def instruction = task.instruction
}

sealed trait InitialSearchResult extends TaskResult
case class InitialSearchSuccess(task: InitialSearchTask) extends InitialSearchResult
case class InitialSearchTimeout(task: InitialSearchTask) extends InitialSearchResult
