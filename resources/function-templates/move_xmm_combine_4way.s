  .text
  .globl move_032_128_[xmm_1]_[xmm_2]_[xmm_3]_[xmm_4]_[xmm_0]
  .type [name], @function
#! maybe-read { %[xmm_1] %[xmm_2] %[xmm_3] %[xmm_4] }
#! maybe-write { %[xmm_0] }
#! must-undef { }
.[name]:
  # ----------------------------------------------------------------------------
  # moves the lowest 32 bits of [xmm_0] to [xmm_1], the next 32 bits to
  # [xmm_2], the next to [xmm_3] and the highest 32 bits to [xmm_4].
  # ----------------------------------------------------------------------------
  #
  movss %[xmm_1], %[xmm_0]
  shufps $0x39, %[xmm_0], %[xmm_0]
  movss %[xmm_2], %[xmm_0]
  shufps $0x39, %[xmm_0], %[xmm_0]
  movss %[xmm_3], %[xmm_0]
  shufps $0x39, %[xmm_0], %[xmm_0]
  movss %[xmm_4], %[xmm_0]
  shufps $0x39, %[xmm_0], %[xmm_0]
  retq

.size [name], .-[name]