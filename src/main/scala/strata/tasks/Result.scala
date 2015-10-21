package strata.tasks

import strata.util.TimingInfo


/**
 * The result of a task in strata
 */
sealed trait TaskResult {
  def task: Task
  def instruction = task.instruction
  def timing: TimingInfo
}

sealed trait InitialSearchResult extends TaskResult
case class InitialSearchSuccess(task: InitialSearchTask, timing: TimingInfo) extends InitialSearchResult {
  override def toString = "Initial search success"
}
case class InitialSearchTimeout(task: InitialSearchTask, timing: TimingInfo) extends InitialSearchResult {
  override def toString = "Initial search timeout"
}
case class InitialSearchError(task: InitialSearchTask, timing: TimingInfo) extends InitialSearchResult {
  override def toString = "Initial search error"
}

sealed trait SecondarySearchResult extends TaskResult
case class SecondarySearchSuccess(task: SecondarySearchTask, kind: SecondarySuccessKind, timing: TimingInfo) extends SecondarySearchResult {
  override def toString = s"Secondary search success: $kind"
}
case class SecondarySearchTimeout(task: SecondarySearchTask, timing: TimingInfo) extends SecondarySearchResult {
  override def toString = "Secondary search timeout"
}
case class SecondarySearchError(task: SecondarySearchTask, timing: TimingInfo) extends SecondarySearchResult {
  override def toString = "Secondary search error"
}

sealed trait SecondarySuccessKind
case class SrkEquivalent() extends SecondarySuccessKind {
  override def toString = s"New program is correct"
}
case class SrkUnknown(testedAgainst: Int, againstEquiv: Boolean) extends SecondarySuccessKind {
  override def toString = s"SMT solver returned unknown while testing against $testedAgainst programs " +
    s"(that are ${if (againstEquiv) "equivalent" else "also unknown"}})"
}
case class SrkCounterExample(nCorrect: Int, nIncorrect: Int) extends SecondarySuccessKind {
  override def toString = s"Found counterexample that removed $nIncorrect programs and kept $nCorrect"
}
