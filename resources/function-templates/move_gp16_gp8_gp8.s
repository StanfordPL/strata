  .text
  .globl move_016_008_[gp16_0]_[gp8_0]_[gp8_1]
  .type [name], @function
#! maybe-read { %[gp16_0] }
#! maybe-write { %[gp8_0] %[gp8_1] }
#! must-undef { %r15 }
.[name]:
  # ----------------------------------------------------------------------------
  # moves [gp16_0] to [gp8_0] and [gp8_1].
  # ----------------------------------------------------------------------------
  pushfq
  movw %[gp16_0], %r15w
  movb %r15b, %[gp8_0]
  shrq $0x8, %r15
  movb %r15b, %[gp8_1]
  popfq
  retq

.size [name], .-[name]