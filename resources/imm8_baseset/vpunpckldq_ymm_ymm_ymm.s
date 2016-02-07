  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                  #  Line  RIP   Bytes  Opcode                
.target:                                #        0     0      OPC=<label>           
  unpcklps %xmm3, %xmm2                 #  1     0     3      OPC=unpcklps_xmm_xmm  
  callq .move_256_128_ymm2_xmm8_xmm9    #  2     0x3   5      OPC=callq_label       
  callq .move_256_128_ymm3_xmm12_xmm13  #  3     0x8   5      OPC=callq_label       
  unpcklps %xmm13, %xmm9                #  4     0xd   4      OPC=unpcklps_xmm_xmm  
  callq .move_128_256_xmm8_xmm9_ymm1    #  5     0x11  5      OPC=callq_label       
  retq                                  #  6     0x16  1      OPC=retq              
                                                                                    
.size target, .-target
