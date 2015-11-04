package strata.data

import java.io.File

import strata.util.Sorting

/**
 * Meta information about a goal instruction.
 */
case class InstructionMeta(def_in: String,
                           live_out: String,
                           def_in_formal: String,
                           live_out_formal: String,
                           black_listed_instructions: Seq[Instruction],
                           initial_searches: Seq[InitialSearchMeta],
                           secondary_searches: Seq[SecondarySearchMeta],
                           equivalence_classes: EquivalenceClasses
                            ) {
}

case class EvaluatedProgram(program: String, score: Score) extends Ordered[EvaluatedProgram] {
  def getFile(instr: Instruction, state: State) = {
    new File(s"${state.getInstructionResultDir(instr)}/$program")
  }

  def compare(that: EvaluatedProgram) = score.compare(that.score)
  override def toString = program

  def asEquivalenceClass = EquivalenceClass(Vector(this))
}

case class EquivalenceClass(programs: Seq[EvaluatedProgram]) extends Ordered[EquivalenceClass] {
  /** Return an equivalence class without any programs whose file doesn't exist any longer. */
  def filterExisting(instr: Instruction, state: State): Option[EquivalenceClass] = {
    val updatedPrograms = programs.filter(p => p.getFile(instr, state).exists)
    if (updatedPrograms.isEmpty) None
    else Some(EquivalenceClass(updatedPrograms))
  }

  def compare(that: EquivalenceClass) = {
    val thisScore = getRepresentativeProgram.score.data
    val thatScore = that.getRepresentativeProgram.score.data
    Sorting.lexographicalCompare(thisScore ++ Vector(programs.length), thatScore ++ Vector(that.programs.length))
  }

  /** Get a representative program (the one with the lowest score. */
  def getRepresentativeProgram = sortedPrograms.head

  /** Programs sorted according to their score. */
  def sortedPrograms = programs.sorted

  /** Number of programs in this class. */
  def size = programs.length

  override def toString = {
    s"EqClass(${sortedPrograms.mkString(", ")})"
  }
}

case class EquivalenceClasses(unorderedClasses: Seq[EquivalenceClass]) {
  def getClasses(minSize: Int = 0) = {
    unorderedClasses.filter(eqClass => eqClass.size >= minSize).sorted
  }

  def nClasses = unorderedClasses.length
  def nPrograms = unorderedClasses.map(x => x.size).sum
}

case class InitialSearchMeta(success: Boolean,
                             budget: Long,
                             iterations: Long,
                             start_ptime: Int
                              )

case class SecondarySearchMeta(n_found: Int,
                               budget: Long,
                               iterations: Long,
                               start_ptime: Int
                                )
