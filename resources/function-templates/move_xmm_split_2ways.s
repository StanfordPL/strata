  .text
  .globl move_128_64_[xmm_0]_[xmm_1]_[xmm_2]
  .type [name], @function
#! maybe-read { %[xmm_0] }
#! maybe-write { %[xmm_1] %[xmm_2] }
#! must-undef { %ymm15 }
.[name]:
  # ----------------------------------------------------------------------------
  # moves the upper 64 bits of [xmm_0] to [xmm_2], and the lower 64 bits
  # to [xmm_1].
  # ----------------------------------------------------------------------------
  #
  # move low bits
  xorpd %[xmm_1], %[xmm_1]
  movsd %[xmm_0], %[xmm_1]
  shufps $0x39, %[xmm_0], %[xmm_0]
  shufps $0x39, %[xmm_0], %[xmm_0]
  #
  # move high bits
  xorpd %[xmm_2], %[xmm_2]
  movsd %[xmm_0], %[xmm_2]
  shufps $0x39, %[xmm_0], %[xmm_0]
  shufps $0x39, %[xmm_0], %[xmm_0]
  retq

.size [name], .-[name]
  retq
