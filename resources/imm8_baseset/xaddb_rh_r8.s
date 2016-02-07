  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text              #  Line  RIP  Bytes  Opcode             
.target:            #        0    0      OPC=<label>        
  movsbl %ah, %eax  #  1     0    3      OPC=movsbl_r32_rh  
  addb %al, %bl     #  2     0x3  2      OPC=addb_r8_r8     
  xchgb %ah, %bl    #  3     0x5  2      OPC=xchgb_r8_rh    
  xchgb %al, %bl    #  4     0x7  2      OPC=xchgb_r8_r8    
  xchgw %ax, %ax    #  5     0x9  3      OPC=xchgw_r16_r16  
  retq              #  6     0xc  1      OPC=retq           
                                                            
.size target, .-target
