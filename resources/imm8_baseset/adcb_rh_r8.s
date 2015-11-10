  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                   #  Line  RIP  Bytes  Opcode           
.target:                 #        0    0      OPC=<label>      
  adcb %ah, %bl          #  1     0    2      OPC=adcb_r8_rh   
  callq .set_szp_for_bl  #  2     0x2  5      OPC=callq_label  
  xchgb %ah, %bl         #  3     0x7  2      OPC=xchgb_r8_rh  
  retq                   #  4     0x9  1      OPC=retq         
                                                               
.size target, .-target
