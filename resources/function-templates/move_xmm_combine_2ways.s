  .text
  .globl move_64_128_[xmm_1]_[xmm_2]_[xmm_0]
  .type [name], @function
#! maybe-read { %[xmm_1] %[xmm_2] }
#! maybe-write { %[xmm_0] }
#! must-undef { %ymm15 }
.[name]:
  # ----------------------------------------------------------------------------
  # moves the lower 64 bits of [xmm_1] to the higher 64 bits of [xmm_0],
  # and the lower 64 bits of [xmm_2] to the lower 64 bits of [xmm_0]
  # ----------------------------------------------------------------------------
  #
  # move low bits
  movsd %[xmm_1], %[xmm_0]
  shufps $0x39, %[xmm_0], %[xmm_0]
  shufps $0x39, %[xmm_0], %[xmm_0]
  #
  # move high bits
  movsd %[xmm_2], %[xmm_0]
  shufps $0x39, %[xmm_0], %[xmm_0]
  shufps $0x39, %[xmm_0], %[xmm_0]
  retq

.size [name], .-[name]
  retq
