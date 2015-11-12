  .text
  .globl move_064_016_[mm_0]_[gp16_0]_[gp16_1]_[gp16_2]_[gp16_3]
  .type [name], @function
#! maybe-read { %[mm_0] }
#! maybe-write { %[gp16_0] %[gp16_1] %[gp16_2] %[gp16_3] }
#! must-undef { %r15 }
.[name]:
  # ----------------------------------------------------------------------------
  # moves the lowest 16 bits of [mm_0] to [gp16_0], the next 16 bits to
  # [gp16_1], the next to [gp16_2] and the highest 16 bits to [gp16_3].
  # ----------------------------------------------------------------------------
  #
  pushfq
  movq %[mm_0], %r15
  movw %r15w, %[gp16_0]
  shrq $0x10, %r15
  movw %r15w, %[gp16_1]
  shrq $0x10, %r15
  movw %r15w, %[gp16_2]
  shrq $0x10, %r15
  movw %r15w, %[gp16_3]
  shrq $0x10, %r15
  popfq
  retq

.size [name], .-[name]