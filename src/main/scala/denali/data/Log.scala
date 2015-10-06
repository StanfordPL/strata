package denali.data

import java.io.File
import java.text.SimpleDateFormat
import java.util.Date

import com.sun.xml.internal.messaging.saaj.util.Base64
import org.json4s._
import org.json4s.native.JsonMethods._
import org.json4s.native.Serialization
import org.json4s.native.Serialization._

/**
 * Helper methods to deal with log entries.
 */
object Log {
  def serializeMessage(logMessage: LogMessage): String = {
    implicit val formats = Serialization.formats(NoTypeHints)
    logMessage.getClass.getSimpleName + ";" + new String(Base64.encode(write(logMessage).getBytes))
  }

  def deserializeMessage(s: String): LogMessage = {
    implicit val formats = new DefaultFormats {
      override def dateFormatter = new SimpleDateFormat("YYYY-MM-dd'T'HH:mm:ss.SSS'Z'")
    }
    val split = s.split(";")
    assert(split.length == 2)
    val decoded = Base64.base64Decode(split(1))
    split(0) match {
      case "LogInitStart" => parse(decoded).extract[LogInitStart]
      case "LogInitEnd" => parse(decoded).extract[LogInitEnd]
      case _ =>
        assert(false)
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
case class ThreadContext(hostname: String, pid: Long, tid: Long)

sealed trait LogMessage {
  /** The date the log message was generated. */
  def time: Date

  /** Where was this message generated. */
  def context: ThreadContext
}

case class LogInitStart(time: Date, context: ThreadContext) extends LogMessage
case class LogInitEnd(time: Date, context: ThreadContext) extends LogMessage
