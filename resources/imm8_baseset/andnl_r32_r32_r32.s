  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text             #  Line  RIP  Bytes  Opcode            
.target:           #        0    0      OPC=<label>       
  orl %ecx, %edx   #  1     0    2      OPC=orl_r32_r32   
  xorl %ecx, %edx  #  2     0x2  2      OPC=xorl_r32_r32  
  movl %edx, %ebx  #  3     0x4  2      OPC=movl_r32_r32  
  orl %edx, %edx   #  4     0x6  2      OPC=orl_r32_r32   
  retq             #  5     0x8  1      OPC=retq          
                                                          
.size target, .-target
