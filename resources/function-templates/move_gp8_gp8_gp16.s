  .text
  .globl move_008_016_[gp8_0]_[gp8_1]_[gp16_0]
  .type [name], @function
#! maybe-read { %[gp8_0] %[gp8_1] }
#! maybe-write { %[gp16_0] }
#! must-undef { %r15 }
.[name]:
  # ----------------------------------------------------------------------------
  # moves [gp8_0] and [gp8_1] to [gp16_0].
  # ----------------------------------------------------------------------------
  pushfq
  movb %[gp8_1], %r15b
  shlq $0x8, %r15
  movb %[gp8_0], %r15b
  movw %r15w, %[gp16_0]
  popfq
  retq

.size [name], .-[name]