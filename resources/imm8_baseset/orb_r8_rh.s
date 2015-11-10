  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text              #  Line  RIP  Bytes  Opcode             
.target:            #        0    0      OPC=<label>        
  movsbl %ah, %edi  #  1     0    3      OPC=movsbl_r32_rh  
  orb %bl, %dil     #  2     0x3  3      OPC=orb_r8_r8      
  xchgb %bl, %dil   #  3     0x6  3      OPC=xchgb_r8_r8    
  retq              #  4     0x9  1      OPC=retq           
                                                            
.size target, .-target
