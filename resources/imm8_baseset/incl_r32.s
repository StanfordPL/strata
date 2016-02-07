  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text               #  Line  RIP   Bytes  Opcode              
.target:             #        0     0      OPC=<label>         
  movq $0x1, %rsi    #  1     0     10     OPC=movq_r64_imm64  
  movswl %si, %edx   #  2     0xa   3      OPC=movswl_r32_r16  
  movsbq %dl, %r15   #  3     0xd   4      OPC=movsbq_r64_r8   
  xaddl %r15d, %ebx  #  4     0x11  4      OPC=xaddl_r32_r32   
  retq               #  5     0x15  1      OPC=retq            
                                                               
.size target, .-target
