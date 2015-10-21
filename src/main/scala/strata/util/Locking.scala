package strata.util

import java.io.File

/**
 * Class to do file-based locking.
 *
 * All coordination happens through files in denali, as to make it easy to run a single experiment on multiple
 * machines. The convention is to use a file '.dir.lock' to indicate locking of a directory, and to use a file
 * '.name.ext.lock' to lock the file 'name.ext'.  The lock file contains the process and thread ID.
 */
object Locking {

  /** Lock a given file.  Blocks until the lock is available. */
  def lockFile(file: File): Unit = {
    lockImpl(getLockNameForFile(file))
  }

  /** Unlock a file. */
  def unlockFile(file: File): Unit = {
    unlockImpl(getLockNameForFile(file))
  }

  def lockedFile[A](file: File)(f: () => A): A = {
    lockFile(file)
    try {
      f()
    } finally {
      unlockFile(file)
    }
  }

  /** Lock a given directory.  Blocks until the lock is available. */
  def lockDir(file: File): Unit = {
    lockImpl(getLockNameForDir(file))
  }

  /** Unlock a directory. */
  def unlockDir(file: File): Unit = {
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

  private def lockImpl(lock: File): Unit = {
    while (!lock.createNewFile()) {
      Thread.sleep(50)
    }
  }

  private def unlockImpl(lock: File): Unit = {
    assert(lock.exists)
    val res = lock.delete()
    assert(res)
  }

  private def getLockNameForFile(file: File): File = {
    new File(s"${file.getParentFile.getPath}/.${file.getName}.lock")
  }

  private def getLockNameForDir(file: File): File = {
    new File(s"${file.getPath}/.dir.lock")
  }
}
