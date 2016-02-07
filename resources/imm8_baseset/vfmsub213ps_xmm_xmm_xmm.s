  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                             #  Line  RIP   Bytes  Opcode                       
.target:                           #        0     0      OPC=<label>                  
  vmovsd %xmm1, %xmm1, %xmm6       #  1     0     4      OPC=vmovsd_xmm_xmm_xmm       
  vmovapd %xmm3, %xmm1             #  2     0x4   4      OPC=vmovapd_xmm_xmm          
  vmovups %xmm2, %xmm9             #  3     0x8   4      OPC=vmovups_xmm_xmm          
  vmaxss %xmm9, %xmm9, %xmm2       #  4     0xc   5      OPC=vmaxss_xmm_xmm_xmm       
  vfmsub231ps %ymm6, %ymm2, %ymm1  #  5     0x11  5      OPC=vfmsub231ps_ymm_ymm_ymm  
  retq                             #  6     0x16  1      OPC=retq                     
                                                                                      
.size target, .-target
