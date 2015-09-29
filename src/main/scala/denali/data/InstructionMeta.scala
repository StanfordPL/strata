package denali.data

/**
 * Meta information about a goal instruction
 */
case class InstructionMeta(def_in: String,
                           live_out: String,
                           def_in_formal: String,
                           live_out_formal: String,
                           initial_searches: Seq[InitialSearchMeta],
                           secondary_searches: Seq[SecondarySearchMeta]
                            )

case class InitialSearchMeta(success: Boolean,
                             budget: Int,
                             iterations: Int,
                             start_ptime: Int
                              )

case class SecondarySearchMeta(n_found: Int,
                               budget: Int,
                               iterations: Int,
                               start_ptime: Int
                                )
