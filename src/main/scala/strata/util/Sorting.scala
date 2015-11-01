package strata.util

/**
 * Helper methods for sorting
 */
object Sorting {
  def lexographicalCompare(a: Seq[Int], b: Seq[Int]): Int = {
    for ((x, y) <- a zip b) {
      val c = x - y
      if (c != 0) return c
    }
    a.size - b.size
  }
}
