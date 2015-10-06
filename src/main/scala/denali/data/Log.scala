package denali.data

import java.lang.management.ManagementFactory
import java.text.SimpleDateFormat
import java.util.{Calendar, Date}

import com.sun.xml.internal.messaging.saaj.util.Base64
import denali.tasks.{TaskResult, Task}
import denali.util.IO
import org.joda.time.DateTime
import org.joda.time.format.DateTimeFormat
import org.json4s._
import org.json4s.native.JsonMethods._
import org.json4s.native.Serialization
import org.json4s.native.Serialization._
import scala.sys.process._

/**
 * Helper methods to deal with log entries.
 */
object Log {
  case object MyDateTimeSerializer extends CustomSerializer[DateTime](format => (
    {
      case JString(s) => new DateTime(s)
      case JNull => null
    },
    {
      case d: DateTime => JString(format.dateFormat.format(d.toDate))
    }
    ))

  def serializeMessage(logMessage: LogMessage): String = {
    implicit val formats = Serialization.formats(NoTypeHints) ++ Vector(MyDateTimeSerializer)
    logMessage.getClass.getSimpleName + ";" + new String(Base64.encode(write(logMessage).getBytes))
  }

  def deserializeMessage(s: String): LogMessage = {
    implicit val formats = org.json4s.DefaultFormats ++ Vector(MyDateTimeSerializer)
    val split = s.split(";")
    assert(split.length == 2)
    val decoded = Base64.base64Decode(split(1))
    split(0) match {
      case "LogInitStart" => parse(decoded).extract[LogInitStart]
      case "LogInitEnd" => parse(decoded).extract[LogInitEnd]
      case "LogEntryPoint" => parse(decoded).extract[LogEntryPoint]
      case _ =>
        assert(assertion = false, s"Unknown message type: ${split(0)}")
        sys.exit(1)
    }
  }
}

/**
 * Context information
 *
 * @param hostname hostname
 * @param pid process id
 * @param tid thread id
 */
case class ThreadContext(hostname: String, pid: Long, tid: Long) {
  override def toString = {
    val hostMinLength = "pinkman01".length + 3
    val host = hostname + (" " * (hostMinLength - hostname.length))
    f"$host / $pid%6d / $tid%6d"
  }
  def fileNameSafe: String = {
    s"$hostname-$pid-$tid"
  }
}

object ThreadContext {
  private var host: Option[String] = None

  def self: ThreadContext = {
    host match {
      case None =>
        host = Some("hostname".!!.stripLineEnd)
      case _ =>
    }
    val pid: Int = ManagementFactory.getRuntimeMXBean.getName.split("@")(0).toInt
    val tid = Thread.currentThread().getId
    ThreadContext(host.get, pid, tid)
  }
}

sealed trait LogMessage {
  /** The date the log message was generated. */
  def time: DateTime

  /** Where was this message generated. */
  def context: ThreadContext

  override def toString = {
    s"[ ${IO.formatTime(time)} / $context ]"
  }
}

trait LogStart extends LogMessage
trait LogEnd extends LogMessage

case class LogEntryPoint(arguments: Seq[String],
                         time: DateTime = DateTime.now(), context: ThreadContext = ThreadContext.self) extends LogMessage {
  override def toString = {
    super.toString + s": entry point: denali ${arguments.mkString(" ")}"
  }
}

case class LogInitStart(time: DateTime = DateTime.now, context: ThreadContext = ThreadContext.self) extends LogStart {
  override def toString = {
    super.toString + ": initialize start"
  }
}

case class LogInitEnd(time: DateTime = DateTime.now(), context: ThreadContext = ThreadContext.self) extends LogEnd {
  override def toString = {
    super.toString + ": initialize end"
  }
}

case class LogTaskStart(task: Task, time: DateTime = DateTime.now, context: ThreadContext = ThreadContext.self) extends LogStart {
  override def toString = {
    super.toString + s": task start: $task"
  }
}

case class LogTaskEnd(task: Task, res: Option[TaskResult], time: DateTime = DateTime.now(), context: ThreadContext = ThreadContext.self) extends LogEnd {
  override def toString = {
    super.toString + s": task end: $task"
  }
}

case class LogError(msg: String, time: DateTime = DateTime.now(), context: ThreadContext = ThreadContext.self) extends LogMessage {
  override def toString = {
    super.toString + s": error: $msg"
  }
}
