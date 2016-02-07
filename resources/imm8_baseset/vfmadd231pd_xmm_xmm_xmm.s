  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                             #  Line  RIP  Bytes  Opcode                       
.target:                           #        0    0      OPC=<label>                  
  vfmadd213pd %xmm1, %xmm2, %xmm3  #  1     0    5      OPC=vfmadd213pd_xmm_xmm_xmm  
  vmovdqu %ymm3, %ymm0             #  2     0x5  4      OPC=vmovdqu_ymm_ymm          
  vmovdqu %xmm0, %xmm1             #  3     0x9  4      OPC=vmovdqu_xmm_xmm          
  retq                             #  4     0xd  1      OPC=retq                     
                                                                                     
.size target, .-target
