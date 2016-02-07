  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                         #  Line  RIP   Bytes  Opcode                    
.target:                       #        0     0      OPC=<label>               
  vmovddup %xmm2, %xmm15       #  1     0     4      OPC=vmovddup_xmm_xmm      
  vpbroadcastq %xmm1, %xmm8    #  2     0x4   5      OPC=vpbroadcastq_xmm_xmm  
  vmulpd %ymm15, %ymm8, %ymm0  #  3     0x9   5      OPC=vmulpd_ymm_ymm_ymm    
  movsd %xmm0, %xmm1           #  4     0xe   4      OPC=movsd_xmm_xmm         
  retq                         #  5     0x12  1      OPC=retq                  
                                                                               
.size target, .-target
