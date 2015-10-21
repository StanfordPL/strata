package strata.util

import scala.language.implicitConversions

/**
 * Color output on the console
 */
trait ColoredOutput {

  implicit def hasColoredString(s: String): ColoredString = new ColoredString(s)

  class ColoredString(s: String) {
    import Console._

    def black = BLACK + s + RESET
    def red = RED + s + RESET
    def green = GREEN + s + RESET
    def yellow = YELLOW + s + RESET
    def blue = BLUE + s + RESET
    def magenta = MAGENTA + s + RESET
    def cyan = CYAN + s + RESET
    def white = WHITE + s + RESET

    def onBlack = BLACK_B + s + RESET
    def onRed = RED_B+ s + RESET
    def onGreen = GREEN_B+ s + RESET
    def onYellow = YELLOW_B + s + RESET
    def onBlue = BLUE_B+ s + RESET
    def onMagenta = MAGENTA_B + s + RESET
    def onCyan = CYAN_B+ s + RESET
    def onWhite = WHITE_B+ s + RESET

    def bold = BOLD + s + RESET
    def underlined = UNDERLINED + s + RESET
    def blink = BLINK + s + RESET
    def reversed = REVERSED + s + RESET
    def invisible = INVISIBLE + s + RESET

    def gray = "\u001b[38;5;244m" + s + RESET
    def color(id: Int) = s"\u001b[38;5;${id}m" + s + RESET
  }
}

/**
 * An object to use the colored output
 */
object ColoredOutput extends ColoredOutput {
  def uncoloredLength(s: String): Int = {
    s.replaceAll("\\e\\[[\\d;]*[^\\d;]","").length
  }
}
