  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                          #  Line  RIP   Bytes  Opcode                    
.target:                                        #        0     0      OPC=<label>               
  callq .move_128_032_xmm2_xmm4_xmm5_xmm6_xmm7  #  1     0     5      OPC=callq_label           
  vdivsd %xmm7, %xmm5, %xmm1                    #  2     0x5   4      OPC=vdivsd_xmm_xmm_xmm    
  vpbroadcastd %xmm4, %ymm8                     #  3     0x9   5      OPC=vpbroadcastd_ymm_xmm  
  vpbroadcastd %xmm6, %ymm9                     #  4     0xe   5      OPC=vpbroadcastd_ymm_xmm  
  callq .move_64_128_xmm8_xmm9_xmm1             #  5     0x13  5      OPC=callq_label           
  retq                                          #  6     0x18  1      OPC=retq                  
                                                                                                
.size target, .-target
