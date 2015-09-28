package denali.tasks


/**
 * The result of a task in denali
 */
sealed trait TaskResult

sealed trait InitialSearchResult extends TaskResult
case class InitialSearchSuccess() extends InitialSearchResult
case class InitialSearchTimeout() extends InitialSearchResult
