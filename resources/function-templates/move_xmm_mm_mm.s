  .text
  .globl move_128_064_[xmm_0]_[mm_0]_[mm_1]
  .type [name], @function
#! maybe-read { %[xmm_0] }
#! maybe-write { %[mm_0] %[mm_1] }
#! must-undef { %r14 %r15 %ymm14 %ymm15 }
.[name]:
  # ----------------------------------------------------------------------------
  # moves the lower 64 bits of [xmm_0] to [mm_0], and the higher 64 bits
  # to [mm_1].
  # ----------------------------------------------------------------------------
  #
  # move lower bits
  movq %[xmm_0], %r14
  movq %r14, %[mm_0]
  #
  # move the shuffling constant to xmm15
  movq $0x0706050403020100, %r15
  movq %r15, %xmm14
  movq $0x0f0e0d0c0b0a0908, %r15
  movq %r15, %xmm15
  punpcklqdq %xmm14, %xmm15
  #
  # swap low and high 64 bytes of [xmm_0]
  pshufb %xmm15, %[xmm_0]
  #
  # move higher bits
  movq %[xmm_0], %r14
  movq %r14, %[mm_1]
  #
  # swap low and high 64 bytes of [xmm_0]
  pshufb %xmm15, %[xmm_0]
  retq

.size [name], .-[name]