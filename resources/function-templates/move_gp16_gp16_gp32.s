  .text
  .globl move_016_032_[gp16_0]_[gp16_1]_[gp32_0]
  .type [name], @function
#! maybe-read { %[gp16_0] %[gp16_1] }
#! maybe-write { %[gp32_0] }
#! must-undef { %r15 }
.[name]:
  # ----------------------------------------------------------------------------
  # moves [gp16_0] and [gp16_1] to [gp32_0].
  # ----------------------------------------------------------------------------
  pushfq
  movw %[gp16_1], %r15w
  shlq $0x10, %r15
  movw %[gp16_0], %r15w
  movl %r15d, %[gp32_0]
  popfq
  retq

.size [name], .-[name]