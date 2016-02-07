  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                               #  Line  RIP   Bytes  Opcode                  
.target:                             #        0     0      OPC=<label>             
  callq .move_128_64_xmm2_xmm8_xmm9  #  1     0     5      OPC=callq_label         
  vmovss %xmm3, %xmm2, %xmm1         #  2     0x5   4      OPC=vmovss_xmm_xmm_xmm  
  subss %xmm1, %xmm8                 #  3     0x9   5      OPC=subss_xmm_xmm       
  movss %xmm8, %xmm1                 #  4     0xe   5      OPC=movss_xmm_xmm       
  retq                               #  5     0x13  1      OPC=retq                
                                                                                   
.size target, .-target
