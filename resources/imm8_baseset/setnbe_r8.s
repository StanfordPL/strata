  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text             #  Line  RIP  Bytes  Opcode             
.target:           #        0    0      OPC=<label>        
  seta %ch         #  1     0    3      OPC=seta_rh        
  movsbw %ch, %bx  #  2     0x3  4      OPC=movsbw_r16_rh  
  retq             #  3     0x7  1      OPC=retq           
                                                           
.size target, .-target
