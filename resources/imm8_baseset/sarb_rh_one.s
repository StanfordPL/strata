  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text             #  Line  RIP  Bytes  Opcode             
.target:           #        0    0      OPC=<label>        
  movsbw %ah, %dx  #  1     0    4      OPC=movsbw_r16_rh  
  xaddb %ah, %ah   #  2     0x4  3      OPC=xaddb_rh_rh    
  sarb $0x1, %dl   #  3     0x7  2      OPC=sarb_r8_one    
  xchgb %dl, %dh   #  4     0x9  2      OPC=xchgb_rh_r8    
  xchgb %ah, %dh   #  5     0xb  2      OPC=xchgb_rh_rh    
  retq             #  6     0xd  1      OPC=retq           
                                                           
.size target, .-target
