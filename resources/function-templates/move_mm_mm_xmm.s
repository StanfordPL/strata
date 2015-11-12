  .text
  .globl move_064_128_[mm_0]_[mm_1]_[xmm_0]
  .type [name], @function
#! maybe-read { %[mm_0] %[mm_1] }
#! maybe-write { %[xmm_0] }
#! must-undef { %r15 %ymm15 }
.[name]:
  # ----------------------------------------------------------------------------
  # moves [mm_0] to the lower 64 bits of [xmm_0], and [mm_1] to the higher
  # 64 bits.
  # ----------------------------------------------------------------------------
  #
  # move lower bits
  movq %[mm_0], %r15
  movq %r15, %[xmm_0]
  #
  # move the higher bits
  movq %[mm_1], %r15
  movq %r15, %xmm15
  punpcklqdq %xmm15, %[xmm_0]
  retq

.size [name], .-[name]