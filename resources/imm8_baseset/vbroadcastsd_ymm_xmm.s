  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                  #  Line  RIP   Bytes  Opcode                    
.target:                                #        0     0      OPC=<label>               
  vpbroadcastq %xmm2, %xmm1             #  1     0     5      OPC=vpbroadcastq_xmm_xmm  
  callq .move_128_64_xmm1_xmm10_xmm11   #  2     0x5   5      OPC=callq_label           
  vmovss %xmm1, %xmm1, %xmm11           #  3     0xa   4      OPC=vmovss_xmm_xmm_xmm    
  callq .move_128_256_xmm10_xmm11_ymm1  #  4     0xe   5      OPC=callq_label           
  callq .move_64_128_xmm10_xmm11_xmm1   #  5     0x13  5      OPC=callq_label           
  retq                                  #  6     0x18  1      OPC=retq                  
                                                                                        
.size target, .-target
