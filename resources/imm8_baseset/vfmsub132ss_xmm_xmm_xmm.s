  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                             #  Line  RIP  Bytes  Opcode                       
.target:                           #        0    0      OPC=<label>                  
  vmovups %xmm1, %xmm0             #  1     0    4      OPC=vmovups_xmm_xmm          
  vfmsub231ps %xmm3, %xmm0, %xmm2  #  2     0x4  5      OPC=vfmsub231ps_xmm_xmm_xmm  
  vmovss %xmm2, %xmm1, %xmm1       #  3     0x9  4      OPC=vmovss_xmm_xmm_xmm       
  retq                             #  4     0xd  1      OPC=retq                     
                                                                                     
.size target, .-target
