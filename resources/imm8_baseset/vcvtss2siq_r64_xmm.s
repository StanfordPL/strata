  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                   #  Line  RIP  Bytes  Opcode                 
.target:                 #        0    0      OPC=<label>            
  cvtss2siq %xmm1, %rbx  #  1     0    5      OPC=cvtss2siq_r64_xmm  
  retq                   #  2     0x5  1      OPC=retq               
                                                                     
.size target, .-target
