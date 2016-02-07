  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text             #  Line  RIP  Bytes  Opcode             
.target:           #        0    0      OPC=<label>        
  movzbw %ah, %dx  #  1     0    4      OPC=movzbw_r16_rh  
  subb %bh, %dl    #  2     0x4  2      OPC=subb_r8_rh     
  retq             #  3     0x6  1      OPC=retq           
                                                           
.size target, .-target
