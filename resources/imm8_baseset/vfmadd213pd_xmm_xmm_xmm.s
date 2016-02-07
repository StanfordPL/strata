  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                             #  Line  RIP   Bytes  Opcode                       
.target:                           #        0     0      OPC=<label>                  
  vmovdqa %xmm1, %xmm7             #  1     0     4      OPC=vmovdqa_xmm_xmm          
  vmovups %xmm2, %xmm1             #  2     0x4   4      OPC=vmovups_xmm_xmm          
  vmovups %xmm3, %xmm6             #  3     0x8   4      OPC=vmovups_xmm_xmm          
  vfmadd132pd %ymm7, %ymm6, %ymm1  #  4     0xc   5      OPC=vfmadd132pd_ymm_ymm_ymm  
  retq                             #  5     0x11  1      OPC=retq                     
                                                                                      
.size target, .-target
