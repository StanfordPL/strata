  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                  #  Line  RIP   Bytes  Opcode                 
.target:                                #        0     0      OPC=<label>            
  punpckldq %xmm3, %xmm2                #  1     0     4      OPC=punpckldq_xmm_xmm  
  callq .move_256_128_ymm2_xmm8_xmm9    #  2     0x4   5      OPC=callq_label        
  callq .move_256_128_ymm3_xmm10_xmm11  #  3     0x9   5      OPC=callq_label        
  punpckldq %xmm11, %xmm9               #  4     0xe   5      OPC=punpckldq_xmm_xmm  
  callq .move_128_256_xmm8_xmm9_ymm1    #  5     0x13  5      OPC=callq_label        
  retq                                  #  6     0x18  1      OPC=retq               
                                                                                     
.size target, .-target
