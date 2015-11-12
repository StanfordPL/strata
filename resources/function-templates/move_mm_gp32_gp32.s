  .text
  .globl move_064_032_[mm_0]_[gp32_0]_[gp32_1]
  .type [name], @function
#! maybe-read { %[mm_0] }
#! maybe-write { %[gp32_0] %[gp32_1] }
#! must-undef { %r15 }
.[name]:
  # ----------------------------------------------------------------------------
  # moves [mm_0] to [gp32_0] and [gp32_1].
  # ----------------------------------------------------------------------------
  pushfq
  movq %[mm_0], %r15
  movl %r15d, %[gp32_0]
  shrq $0x20, %r15
  movl %r15d, %[gp32_1]
  popfq
  retq

.size [name], .-[name]