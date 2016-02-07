  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text              #  Line  RIP  Bytes  Opcode             
.target:            #        0    0      OPC=<label>        
  movsbl %ah, %ecx  #  1     0    3      OPC=movsbl_r32_rh  
  xchgb %bl, %ch    #  2     0x3  2      OPC=xchgb_rh_r8    
  sbbb %ah, %ch     #  3     0x5  2      OPC=sbbb_rh_rh     
  xchgb %bl, %ch    #  4     0x7  2      OPC=xchgb_rh_r8    
  retq              #  5     0x9  1      OPC=retq           
                                                            
.size target, .-target
