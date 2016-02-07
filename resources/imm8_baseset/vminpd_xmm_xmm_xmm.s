  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                          #  Line  RIP   Bytes  Opcode                  
.target:                                        #        0     0      OPC=<label>             
  vmovapd %xmm3, %xmm9                          #  1     0     4      OPC=vmovapd_xmm_xmm     
  callq .move_128_032_xmm2_xmm4_xmm5_xmm6_xmm7  #  2     0x4   5      OPC=callq_label         
  vmovss %xmm4, %xmm2, %xmm6                    #  3     0x9   4      OPC=vmovss_xmm_xmm_xmm  
  vminpd %ymm9, %ymm6, %ymm6                    #  4     0xd   5      OPC=vminpd_ymm_ymm_ymm  
  vmovupd %xmm6, %xmm1                          #  5     0x12  4      OPC=vmovupd_xmm_xmm     
  retq                                          #  6     0x16  1      OPC=retq                
                                                                                              
.size target, .-target
