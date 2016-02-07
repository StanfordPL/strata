  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text           #  Line  RIP  Bytes  Opcode          
.target:         #        0    0      OPC=<label>     
  addb %ah, %bl  #  1     0    2      OPC=addb_r8_rh  
  movb %bl, %ah  #  2     0x2  2      OPC=movb_rh_r8  
  retq           #  3     0x4  1      OPC=retq        
                                                      
.size target, .-target
