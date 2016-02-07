  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text             #  Line  RIP  Bytes  Opcode             
.target:           #        0    0      OPC=<label>        
  movzbw %ah, %ax  #  1     0    4      OPC=movzbw_r16_rh  
  movsbw %al, %dx  #  2     0x4  4      OPC=movsbw_r16_r8  
  negb %dl         #  3     0x8  2      OPC=negb_r8        
  movb %dl, %ah    #  4     0xa  2      OPC=movb_rh_r8     
  retq             #  5     0xc  1      OPC=retq           
                                                           
.size target, .-target
