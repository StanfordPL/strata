  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                #  Line  RIP   Bytes  Opcode                    
.target:                              #        0     0      OPC=<label>               
  vsqrtss %xmm2, %xmm2, %xmm3         #  1     0     4      OPC=vsqrtss_xmm_xmm_xmm   
  vmovlhps %xmm2, %xmm3, %xmm1        #  2     0x4   4      OPC=vmovlhps_xmm_xmm_xmm  
  callq .move_256_128_ymm1_xmm8_xmm9  #  3     0x8   5      OPC=callq_label           
  unpckhps %xmm1, %xmm8               #  4     0xd   4      OPC=unpckhps_xmm_xmm      
  vpbroadcastq %xmm8, %ymm1           #  5     0x11  5      OPC=vpbroadcastq_ymm_xmm  
  retq                                #  6     0x16  1      OPC=retq                  
                                                                                      
.size target, .-target
