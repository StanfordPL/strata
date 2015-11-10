  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text             #  Line  RIP  Bytes  Opcode             
.target:           #        0    0      OPC=<label>        
  movzbw %ah, %di  #  1     0    4      OPC=movzbw_r16_rh  
  orb %dil, %bl    #  2     0x4  3      OPC=orb_r8_r8      
  xchgb %ah, %bl   #  3     0x7  2      OPC=xchgb_r8_rh    
  retq             #  4     0x9  1      OPC=retq           
                                                           
.size target, .-target
