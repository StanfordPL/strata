  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text               #  Line  RIP  Bytes  Opcode              
.target:             #        0    0      OPC=<label>         
  movslq %ecx, %r14  #  1     0    3      OPC=movslq_r64_r32  
  xchgb %cl, %r14b   #  2     0x3  3      OPC=xchgb_r8_r8     
  cmoval %ecx, %ebx  #  3     0x6  3      OPC=cmoval_r32_r32  
  retq               #  4     0x9  1      OPC=retq            
                                                              
.size target, .-target
