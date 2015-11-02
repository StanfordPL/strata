  .text
  .globl move_128_032_[xmm_0]_[xmm_1]_[xmm_2]_[xmm_3]_[xmm_4]
  .type [name], @function
#! maybe-read { %[xmm_0] }
#! maybe-write { %[xmm_1] %[xmm_2] %[xmm_3] %[xmm_4] }
#! must-undef { }
.[name]:
  # ----------------------------------------------------------------------------
  # moves the lowest 32 bits of [xmm_0] to [xmm_1], the next 32 bits to
  # [xmm_2], the next to [xmm_3] and the highest 32 bits to [xmm_4].
  # ----------------------------------------------------------------------------
  #
  xorpd %[xmm_1], %[xmm_1]
  xorpd %[xmm_2], %[xmm_2]
  xorpd %[xmm_3], %[xmm_3]
  xorpd %[xmm_4], %[xmm_4]
  movss %[xmm_0], %[xmm_1]
  shufps $0x39, %[xmm_0], %[xmm_0]
  movss %[xmm_0], %[xmm_2]
  shufps $0x39, %[xmm_0], %[xmm_0]
  movss %[xmm_0], %[xmm_3]
  shufps $0x39, %[xmm_0], %[xmm_0]
  movss %[xmm_0], %[xmm_4]
  shufps $0x39, %[xmm_0], %[xmm_0]
  retq

.size [name], .-[name]