  .text
  .globl move_032_016_[gp32_0]_[gp16_0]_[gp16_1]
  .type [name], @function
#! maybe-read { %[gp32_0] }
#! maybe-write { %[gp16_0] %[gp16_1] }
#! must-undef { %r15 }
.[name]:
  # ----------------------------------------------------------------------------
  # moves [gp32_0] to [gp16_0] and [gp16_1].
  # ----------------------------------------------------------------------------
  pushfq
  movl %[gp32_0], %r15d
  movw %r15w, %[gp16_0]
  shrq $0x10, %r15
  movw %r15w, %[gp16_1]
  popfq
  retq

.size [name], .-[name]