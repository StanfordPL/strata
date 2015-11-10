  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                 #  Line  RIP  Bytes  Opcode                 
.target:                               #        0    0      OPC=<label>            
  vmovsldup %xmm2, %xmm3               #  1     0    4      OPC=vmovsldup_xmm_xmm  
  callq .move_128_64_xmm3_xmm12_xmm13  #  2     0x4  5      OPC=callq_label        
  callq .move_64_128_xmm12_xmm13_xmm1  #  3     0x9  5      OPC=callq_label        
  retq                                 #  4     0xe  1      OPC=retq               
                                                                                   
.size target, .-target
