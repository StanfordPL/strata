  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text             #  Line  RIP  Bytes  Opcode             
.target:           #        0    0      OPC=<label>        
  movzbw %ah, %cx  #  1     0    4      OPC=movzbw_r16_rh  
  xaddb %bh, %cl   #  2     0x4  3      OPC=xaddb_r8_rh    
  movb %cl, %ah    #  3     0x7  2      OPC=movb_rh_r8     
  retq             #  4     0x9  1      OPC=retq           
                                                           
.size target, .-target
