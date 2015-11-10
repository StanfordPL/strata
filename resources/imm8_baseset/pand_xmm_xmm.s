  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                 #  Line  RIP   Bytes  Opcode               
.target:                               #        0     0      OPC=<label>          
  callq .move_128_64_xmm2_xmm10_xmm11  #  1     0     5      OPC=callq_label      
  vmovdqa %xmm1, %xmm8                 #  2     0x5   4      OPC=vmovdqa_xmm_xmm  
  callq .move_64_128_xmm10_xmm11_xmm1  #  3     0x9   5      OPC=callq_label      
  andpd %xmm8, %xmm1                   #  4     0xe   5      OPC=andpd_xmm_xmm    
  retq                                 #  5     0x13  1      OPC=retq             
                                                                                  
.size target, .-target
