  .text
  .globl move_016_064_[gp16_0]_[gp16_1]_[gp16_2]_[gp16_3]_[mm_0]
  .type [name], @function
#! maybe-read { %[gp16_0] %[gp16_1] %[gp16_2] %[gp16_3] }
#! maybe-write { %[mm_0] }
#! must-undef { %r15 }
.[name]:
  # ----------------------------------------------------------------------------
  # moves the lowest 16 bits of [mm_0] to [gp16_0], the next 16 bits to
  # [gp16_1], the next to [gp16_2] and the highest 16 bits to [gp16_3].
  # ----------------------------------------------------------------------------
  #
  pushfq
  movw %[gp16_3], %r15w
  shlq $0x10, %r15
  movw %[gp16_2], %r15w
  shlq $0x10, %r15
  movw %[gp16_1], %r15w
  shlq $0x10, %r15
  movw %[gp16_0], %r15w
  movq %r15, %[mm_0]
  popfq
  retq

.size [name], .-[name]