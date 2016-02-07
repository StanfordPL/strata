  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                             #  Line  RIP   Bytes  Opcode                       
.target:                           #        0     0      OPC=<label>                  
  vmovups %xmm1, %xmm9             #  1     0     4      OPC=vmovups_xmm_xmm          
  vmovupd %xmm2, %xmm1             #  2     0x4   4      OPC=vmovupd_xmm_xmm          
  vmovapd %xmm3, %xmm6             #  3     0x8   4      OPC=vmovapd_xmm_xmm          
  vfmadd132ps %ymm6, %ymm1, %ymm9  #  4     0xc   5      OPC=vfmadd132ps_ymm_ymm_ymm  
  vmovupd %xmm9, %xmm1             #  5     0x11  5      OPC=vmovupd_xmm_xmm          
  retq                             #  6     0x16  1      OPC=retq                     
                                                                                      
.size target, .-target
