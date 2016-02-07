  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                            #  Line  RIP   Bytes  Opcode               
.target:                                          #        0     0      OPC=<label>          
  callq .move_128_032_xmm1_xmm8_xmm9_xmm10_xmm11  #  1     0     5      OPC=callq_label      
  vmovdqu %xmm2, %xmm5                            #  2     0x5   4      OPC=vmovdqu_xmm_xmm  
  vsqrtps %ymm5, %ymm2                            #  3     0x9   4      OPC=vsqrtps_ymm_ymm  
  vmovapd %xmm2, %xmm8                            #  4     0xd   4      OPC=vmovapd_xmm_xmm  
  callq .move_032_128_xmm8_xmm9_xmm10_xmm11_xmm1  #  5     0x11  5      OPC=callq_label      
  retq                                            #  6     0x16  1      OPC=retq             
                                                                                             
.size target, .-target
