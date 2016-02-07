  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text           #  Line  RIP  Bytes  Opcode          
.target:         #        0    0      OPC=<label>     
  clc            #  1     0    1      OPC=clc         
  sbbb %cl, %bl  #  2     0x1  2      OPC=sbbb_r8_r8  
  retq           #  3     0x3  1      OPC=retq        
                                                      
.size target, .-target
