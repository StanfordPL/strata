  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                #  Line  RIP  Bytes  Opcode               
.target:              #        0    0      OPC=<label>          
  cmovzl %ebx, %ecx   #  1     0    3      OPC=cmovzl_r32_r32   
  cmovnll %ecx, %ebx  #  2     0x3  3      OPC=cmovnll_r32_r32  
  retq                #  3     0x6  1      OPC=retq             
                                                                
.size target, .-target
