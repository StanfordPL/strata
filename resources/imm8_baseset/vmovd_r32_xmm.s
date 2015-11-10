  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text              #  Line  RIP   Bytes  Opcode              
.target:            #        0     0      OPC=<label>         
  movq $0x40, %rbx  #  1     0     10     OPC=movq_r64_imm64  
  movd %xmm1, %eax  #  2     0xa   4      OPC=movd_r32_xmm    
  xaddl %ebx, %eax  #  3     0xe   3      OPC=xaddl_r32_r32   
  retq              #  4     0x11  1      OPC=retq            
                                                              
.size target, .-target
