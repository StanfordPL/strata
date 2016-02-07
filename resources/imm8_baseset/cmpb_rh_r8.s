  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text             #  Line  RIP  Bytes  Opcode             
.target:           #        0    0      OPC=<label>        
  movzbw %ah, %bp  #  1     0    4      OPC=movzbw_r16_rh  
  subb %bl, %bpl   #  2     0x4  3      OPC=subb_r8_r8     
  retq             #  3     0x7  1      OPC=retq           
                                                           
.size target, .-target
