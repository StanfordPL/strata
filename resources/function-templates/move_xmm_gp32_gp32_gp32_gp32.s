  .text
  .globl move_128_032_[xmm_0]_[gp32_0]_[gp32_1]_[gp32_2]_[gp32_3]
  .type [name], @function
#! maybe-read { %[xmm_0] }
#! maybe-write { %[gp32_0] %[gp32_1] %[gp32_2] %[gp32_3] }
#! must-undef { }
.[name]:
  # ----------------------------------------------------------------------------
  # moves the lowest 32 bits of [xmm_0] to [gp32_0], and so on.
  # ----------------------------------------------------------------------------
  #
  movd %[xmm_0], %[gp32_0]
  shufps $0x39, %[xmm_0], %[xmm_0]
  movd %[xmm_0], %[gp32_1]
  shufps $0x39, %[xmm_0], %[xmm_0]
  movd %[xmm_0], %[gp32_2]
  shufps $0x39, %[xmm_0], %[xmm_0]
  movd %[xmm_0], %[gp32_3]
  shufps $0x39, %[xmm_0], %[xmm_0]
  retq

.size [name], .-[name]