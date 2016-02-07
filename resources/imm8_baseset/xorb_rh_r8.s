  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                   #  Line  RIP  Bytes  Opcode           
.target:                 #        0    0      OPC=<label>      
  xorb %ah, %bl          #  1     0    2      OPC=xorb_r8_rh   
  movb %bl, %ah          #  2     0x2  2      OPC=movb_rh_r8   
  clc                    #  3     0x4  1      OPC=clc          
  callq .set_szp_for_bl  #  4     0x5  5      OPC=callq_label  
  retq                   #  5     0xa  1      OPC=retq         
                                                               
.size target, .-target
