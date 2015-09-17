  .text
  .globl move_256_128_[ymm_0]_[xmm_0]_[xmm_1]
  .type [name], @function
#! maybe-read { %[ymm_0] }
#! maybe-write { %[xmm_0] %[xmm_1] }
#! must-undef { %ymm15 }
.[name]:
  # ----------------------------------------------------------------------------
  # moves the lower 128 bits of [ymm_0] to [xmm_0], and the higher 128 bits
  # to [xmm_1].
  # ----------------------------------------------------------------------------
  #
  # move lower bits
  movupd %[ymm_0_as-xmm], %[xmm_0]
  #
  # mov low and high 128 bytes of [ymm_0] to ymm15, and swap them
  vperm2f128 $0x1, %[ymm_0], %[ymm_0], %ymm15
  #
  # move higher bits
  movupd %xmm15, %[xmm_1]
  retq

.size [name], .-[name]
  retq
