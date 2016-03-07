package strata.util

import scala.collection.mutable.{ArrayBuffer, ListBuffer}

/**
 * Helper to visualize distributions.
 */
case class Distribution(data: Seq[Long]) {

  def histogram(nBins: Int): String = {
    val (min, max) = (data.min, data.max)
    val realNBins = if (max - min + 1 < nBins) {
      (max - min + 1).toInt
    } else {
      nBins
    }
    val binSize = (max - min + 1).toDouble / realNBins.toDouble

    var upperBound = min + binSize
    var n = 0
    var i = 0
    val listB = ArrayBuffer[Long]()
    for (d <- data.sorted) {
      if (d < upperBound) {
        n += 1
      } else {
        while (d >= upperBound) {
          listB.append(n)
          n = 0
          upperBound += binSize
        }
        n += 1
      }
    }
    listB.append(n)

    val list = listB.toArray
    val maxN = list.max
    val width = 40
    val boundsChars = max.toString.length
    (for (i <- 0 to (realNBins - 1)) yield {
      val n = list(i)
      val lower = (min + i * binSize).floor.toLong
      val upper = (min + (i + 1) * binSize).floor.toLong
      val lowerStr = if (i == 0) " " * (boundsChars + 2)
      else (" " * (boundsChars - lower.toString.length)) + lower.toString + " ≤"
      val upperStr = if (i == realNBins - 1) " " * (boundsChars + 2)
      else "< " + upper.toString + (" " * (boundsChars - upper.toString.length))
      val thingies = "#" * (n / maxN.toDouble * width).round.toInt
      val boundStr = if (i != 0 && i != realNBins - 1 && lower == upper - 1) {
        (" " * (boundsChars + 2)) + " i = " + lower.toString + (" " * (boundsChars - lower.toString.length))
      } else {
        lowerStr + " i " + upperStr
      }

      boundStr + ": " + thingies + (" " * (width - thingies.length)) + s" ${Stats.percentage(n, data.length)}"
    }).mkString("\n")
  }

  def info(title: String): String = {
    if (data.isEmpty) {
      s"Distribution of $title is empty"
    } else {
      s"Distribution of $title\n" +
        histogram(15) + "\n" +
        s"Total elements: ${data.length}\n" +
        s"Minimum:        ${data.min}\n" +
        s"Median:         ${median(data)}\n" +
        s"Maximum:        ${data.max}\n"
    }
  }

  private def median(arr: Seq[Long]) = {
    Stats.median(arr)
  }

}

object Stats {
  def percentage(p: Long, total: Long, formatter: (Long => String) = _.toString, minLength: Int = 0): String = {
    if (total == 0) {
      assert(p == 0)
      "0"
    } else {
      val percentage = p.toDouble / total.toDouble * 100.0
      val pFormatted = formatter(p)
      (" " * (Math.max(minLength, formatter(total).length) - pFormatted.length)) + f"$pFormatted ($percentage%6.2f %%)"
    }
  }

  def median(arr: Seq[Long]): Long = {
    assert(arr.nonEmpty)
    arr.sorted.apply((arr.size - 1) / 2)
  }

  def mean(arr: Seq[Long]): Double = {
    assert(arr.nonEmpty)
    arr.sum.toDouble / arr.length.toDouble
  }

  /** Describe the distrbution given as a sorted list. */
  def describe[A, B >: A](data: Seq[A], title: String)(implicit ord : scala.math.Ordering[B]) = {
    val data2 = data.sorted(ord)
    val n = data2.length
    s"Information about '$title'\n" +
      s"Size:    $n" + (if (data2.isEmpty) ""
    else {
      s"\nMinimum: ${data2.head}\n" +
      s"1/4 q:   ${data2.apply(n / 4)}\n" +
      s"Median:  ${data2.apply(n / 2)}\n" +
      s"3/4 q:   ${data2.apply(n * 3 / 4)}\n" +
      s"Maximum: ${data2.last}"
    })
  }
}
