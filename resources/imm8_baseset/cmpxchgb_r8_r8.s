  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text               #  Line  RIP  Bytes  Opcode              
.target:             #        0    0      OPC=<label>         
  movb %bl, %dh      #  1     0    2      OPC=movb_rh_r8      
  cmpxchgb %cl, %dh  #  2     0x2  3      OPC=cmpxchgb_rh_r8  
  xchgb %dh, %bl     #  3     0x5  2      OPC=xchgb_r8_rh     
  retq               #  4     0x7  1      OPC=retq            
                                                              
.size target, .-target
