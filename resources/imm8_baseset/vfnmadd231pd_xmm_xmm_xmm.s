  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                               #  Line  RIP   Bytes  Opcode                        
.target:                             #        0     0      OPC=<label>                   
  vmovupd %xmm3, %xmm10              #  1     0     4      OPC=vmovupd_xmm_xmm           
  vmovapd %xmm1, %xmm1               #  2     0x4   4      OPC=vmovapd_xmm_xmm           
  vmovss %xmm2, %xmm2, %xmm9         #  3     0x8   4      OPC=vmovss_xmm_xmm_xmm        
  vfnmadd132pd %ymm10, %ymm1, %ymm9  #  4     0xc   5      OPC=vfnmadd132pd_ymm_ymm_ymm  
  vmovups %xmm9, %xmm1               #  5     0x11  5      OPC=vmovups_xmm_xmm           
  retq                               #  6     0x16  1      OPC=retq                      
                                                                                         
.size target, .-target
