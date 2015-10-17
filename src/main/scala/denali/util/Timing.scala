package denali.util

import denali.util.TimingKind.TimingKind

/**
 * A class to collect timing information
 */
case class TimingBuilder() {

  private val timings = collection.mutable.Map[TimingKind, Long]()
  private val start = Timing.start

  /** Time a task. */
  def timeOperation[A](kind: TimingKind)(block: => A): A = {
    val t0 = System.nanoTime()
    val result = block // call by name
    val t1 = System.nanoTime()
    insert(kind, t1 - t0)
    result
  }

  /** Manually insert a timing. */
  def insert(kind: TimingKind, time: Long): Unit = {
    if (timings.contains(kind)) {
      timings(kind) += time
    } else {
      timings(kind) = time
    }
  }

  /** Get the result. */
  def result: Timing.TimingMap = {
    assert(!timings.contains(TimingKind.Total))
    insert(TimingKind.Total, start.stop)
    timings.toMap
  }
}

object TimingKind extends Enumeration {
  type TimingKind = Value
  val Search, Verification, Total = Value
}

object Timing {

  type TimingMap = Map[TimingKind, Long]

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
