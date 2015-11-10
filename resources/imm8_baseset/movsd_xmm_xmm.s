  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                         #  Line  RIP  Bytes  Opcode                    
.target:                       #        0    0      OPC=<label>               
  vpbroadcastq %xmm2, %xmm14   #  1     0    5      OPC=vpbroadcastq_xmm_xmm  
  vsubss %xmm1, %xmm14, %xmm7  #  2     0x5  4      OPC=vsubss_xmm_xmm_xmm    
  movhlps %xmm7, %xmm1         #  3     0x9  3      OPC=movhlps_xmm_xmm       
  retq                         #  4     0xc  1      OPC=retq                  
                                                                              
.size target, .-target
