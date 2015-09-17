  .text
  .globl move_032_064_[gp32_0]_[gp32_1]_[gp64_0]
  .type [name], @function
#! maybe-read { %[gp32_0] %[gp32_1] }
#! maybe-write { %[gp64_0] }
#! must-undef { %r14 %r15 }
.[name]:
  # ----------------------------------------------------------------------------
  # moves [gp32_0] and [gp32_1] to [gp64_0].
  # ----------------------------------------------------------------------------
  pushfq
  movl %[gp32_1], %r15d
  shlq $0x20, %r15
  movl %[gp32_0], %r14d
  orq %r14, %r15
  movq %r15, %[gp64_0]
  popfq
  retq

.size [name], .-[name]