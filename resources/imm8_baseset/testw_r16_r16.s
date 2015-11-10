  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text           #  Line  RIP  Bytes  Opcode            
.target:         #        0    0      OPC=<label>       
  andw %cx, %bx  #  1     0    3      OPC=andw_r16_r16  
  clc            #  2     0x3  1      OPC=clc           
  retq           #  3     0x4  1      OPC=retq          
                                                        
.size target, .-target
