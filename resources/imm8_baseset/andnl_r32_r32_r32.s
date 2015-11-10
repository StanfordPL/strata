  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text             #  Line  RIP  Bytes  Opcode            
.target:           #        0    0      OPC=<label>       
  orl %ecx, %edx   #  1     0    2      OPC=orl_r32_r32   
  xorl %edx, %ecx  #  2     0x2  2      OPC=xorl_r32_r32  
  movl %ecx, %ebx  #  3     0x4  2      OPC=movl_r32_r32  
  retq             #  4     0x6  1      OPC=retq          
                                                          
.size target, .-target
