package strata.util

import java.io.File
import java.nio.channels.{FileChannel, FileLock}
import java.nio.file.StandardOpenOption

import strata.data.ThreadContext

import scala.collection.mutable

/**
 * Class to do file-based locking.
 *
 * All coordination happens through files in strata, as to make it easy to run a single experiment on multiple
 * machines. The convention is to use a file '.dir.lock' to indicate locking of a directory, and to use a file
 * '.name.ext.lock' to lock the file 'name.ext'.  The lock file contains the process and thread ID.
 */
object Locking {

  val a = new Object
  val b = new Object

  /** Initialize locking for a path. */
  def initFile(path: File): Unit = {
    val lock = getLockNameForFile(path)
    if (!lock.exists()) {
      lock.createNewFile()
    }
  }

  /** Initialize locking for a path. */
  def initDir(path: File): Unit = {
    val lock = getLockNameForDir(path)
    println(lock)
    if (!lock.exists()) {
      lock.createNewFile()
    }
  }

  /** Lock a given file.  Blocks until the lock is available. */
  private def lockFile(file: File): Unit = {
    lockImpl(getLockNameForFile(file))
  }

  /** Unlock a file. */
  private def unlockFile(file: File): Unit = {
    unlockImpl(getLockNameForFile(file))
  }

  def lockedFile[A](file: File)(f: () => A): A = {
    a.synchronized {
      lockFile(file)
      try {
        f()
      } finally {
        unlockFile(file)
      }
    }
  }

  def lockedDir[A](dir: File)(f: () => A): A = {
    b.synchronized {
      lockDir(dir)
      try {
        f()
      } finally {
        unlockDir(dir)
      }
    }
  }

  /** Lock a given directory.  Blocks until the lock is available. */
  private def lockDir(file: File): Unit = {
    lockImpl(getLockNameForDir(file))
  }

  /** Unlock a directory. */
  private def unlockDir(file: File): Unit = {
    unlockImpl(getLockNameForDir(file))
  }

  def cleanupFile(file: File): Unit = {
    val lock = getLockNameForFile(file)
    if (lock.exists) {
      IO.info(s"Remove lock for the file '$file'.")
      lock.delete()
    }
  }

  def cleanupDir(dir: File): Unit = {
    val lock = getLockNameForDir(dir)
    if (lock.exists) {
      IO.info(s"Remove lock for the folder '$dir'.")
      lock.delete()
    }
  }

  private def myLockName(lock: File): File = {
    new File(s"$lock.locked-by-${ThreadContext.self.fileNameSafe}")
  }

  private def lockImpl(lock: File): Unit = {
    val start = Timing.start
    val mylock = myLockName(lock)
    while (!lock.renameTo(mylock)) {
      Thread.sleep(100)
    }
    assert(!lock.exists())
    assert(mylock.exists())
    println((start.stop / 1000))
  }

  private def unlockImpl(lock: File): Unit = {
    val mylock = myLockName(lock)
    assert(!lock.exists())
    assert(mylock.exists())
    val renamed = mylock.renameTo(lock)
    assert(renamed)
    assert(lock.exists())
    assert(!mylock.exists())
  }

  private def getLockNameForFile(file: File): File = {
    new File(s"${file.getParentFile.getPath}/.${file.getName}.lock")
  }

  private def getLockNameForDir(file: File): File = {
    new File(s"${file.getPath}/.dir.lock")
  }
}
