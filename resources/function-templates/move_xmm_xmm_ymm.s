  .text
  .globl move_128_256_[xmm_0]_[xmm_1]_[ymm_0]
  .type [name], @function
#! maybe-read { %[xmm_0] %[xmm_1] }
#! maybe-write { %[ymm_0] }
#! must-undef { %ymm15 }
.[name]:
  # ----------------------------------------------------------------------------
  # moves [xmm_0] to the lower 128 bits of [ymm_0], and [xmm_1] to the higher
  # 128 bits of [ymm_0].
  # ----------------------------------------------------------------------------
  #
  # move higher bits
  movupd %[xmm_1], %[ymm_0_as-xmm]
  #
  # swap low and high bits in [ymm_0]
  vperm2f128 $0x1, %[ymm_0], %[ymm_0], %ymm15
  vmovupd %ymm15, %[ymm_0]
  #
  # move lower bits
  movupd %[xmm_0], %[ymm_0_as-xmm]
  retq

.size [name], .-[name]
  retq
