package denali.tasks

import denali.util.Timing.TimingMap


/**
 * The result of a task in denali
 */
sealed trait TaskResult {
  def task: Task
  def instruction = task.instruction
}

sealed trait InitialSearchResult extends TaskResult
case class InitialSearchSuccess(task: InitialSearchTask, timing: TimingMap) extends InitialSearchResult {
  override def toString = "initial search success"
}
case class InitialSearchTimeout(task: InitialSearchTask, timing: TimingMap) extends InitialSearchResult {
  override def toString = "initial search timeout"
}
case class InitialSearchError(task: InitialSearchTask, timing: TimingMap) extends InitialSearchResult {
  override def toString = "initial search error"
}

sealed trait SecondarySearchResult extends TaskResult
case class SecondarySearchSuccess(task: SecondarySearchTask, timing: TimingMap) extends SecondarySearchResult {
  override def toString = "secondary search success"
}
case class SecondarySearchTimeout(task: SecondarySearchTask, timing: TimingMap) extends SecondarySearchResult {
  override def toString = "secondary search timeout"
}
case class SecondarySearchError(task: SecondarySearchTask, timing: TimingMap) extends SecondarySearchResult {
  override def toString = "secondary search error"
}
