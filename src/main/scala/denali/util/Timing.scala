package denali.util

/**
 * A class to collect timing information
 */
case class TimingBuilder() {

  private val timings = collection.mutable.Map[String, Long]()
  private val start = Timing.start

  /** Time a task. */
  def timeOperation[A](kind: String)(block: => A): A = {
    val t0 = System.nanoTime()
    val result = block // call by name
    val t1 = System.nanoTime()
    insert(kind, t1 - t0)
    result
  }

  /** Manually insert a timing. */
  def insert(kind: String, time: Long): Unit = {
    if (timings.contains(kind)) {
      timings(kind) += time
    } else {
      timings(kind) = time
    }
  }

  /** Get the result. */
  def result: TimingInfo = {
    assert(!timings.contains(TimingKind.Total))
    insert(TimingKind.Total, start.stop)
    TimingInfo(timings.toMap)
  }
}

/** A wrapper for more convenient access. */
case class TimingInfo(data: Map[String, Long]) {

}

object TimingKind extends Enumeration {
  type TimingKind = String
  val Search = "search"
  val Verification = "verification"
  val Testing = "testing" // running testcases
  val Total = "total"
}

object Timing {

  /** Time an operation. */
  def timeOperation[A](block: => A): (A, Long) = {
    val t0 = System.nanoTime()
    val result = block // call by name
    val t1 = System.nanoTime()
    (result, t1 - t0)
  }

  /** Manually start a timer. */
  def start: TimingToken = {
    TimingToken(System.nanoTime())
  }
}

case class TimingToken(start: Long) {
  /** Stop the timer. */
  def stop: Long = {
    System.nanoTime() - start
  }
}
