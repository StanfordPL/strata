  .text
  .globl move_064_128_[gp64_0]_[gp64_1]_[xmm_0]
  .type [name], @function
#! maybe-read { %[gp64_0] %[gp64_1] }
#! maybe-write { %[xmm_0] }
#! must-undef { %ymm15 }
.[name]:
  # ----------------------------------------------------------------------------
  # moves [gp64_0] to the lower 64 bits of [xmm_0], and [gp64_1] to the higher
  # 64 bits.
  # ----------------------------------------------------------------------------
  #
  # move lower bits
  movq %[gp64_0], %[xmm_0]
  #
  # move the higher bits
  movq %[gp64_1], %xmm15
  punpcklqdq %xmm15, %[xmm_0]
  retq

.size [name], .-[name]