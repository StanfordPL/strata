  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                             #  Line  RIP   Bytes  Opcode                       
.target:                           #        0     0      OPC=<label>                  
  vmovss %xmm1, %xmm1, %xmm0       #  1     0     4      OPC=vmovss_xmm_xmm_xmm       
  vmovups %xmm3, %xmm7             #  2     0x4   4      OPC=vmovups_xmm_xmm          
  vmovapd %xmm2, %xmm1             #  3     0x8   4      OPC=vmovapd_xmm_xmm          
  vfmsub213pd %ymm0, %ymm1, %ymm7  #  4     0xc   5      OPC=vfmsub213pd_ymm_ymm_ymm  
  vmovdqa %xmm7, %xmm1             #  5     0x11  4      OPC=vmovdqa_xmm_xmm          
  retq                             #  6     0x15  1      OPC=retq                     
                                                                                      
.size target, .-target
