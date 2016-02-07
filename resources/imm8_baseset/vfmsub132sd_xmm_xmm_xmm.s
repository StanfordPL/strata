  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                             #  Line  RIP  Bytes  Opcode                       
.target:                           #        0    0      OPC=<label>                  
  vfmsub231pd %xmm3, %xmm1, %xmm2  #  1     0    5      OPC=vfmsub231pd_xmm_xmm_xmm  
  vmovups %xmm1, %xmm11            #  2     0x5  4      OPC=vmovups_xmm_xmm          
  vmovsd %xmm2, %xmm11, %xmm1      #  3     0x9  4      OPC=vmovsd_xmm_xmm_xmm       
  retq                             #  4     0xd  1      OPC=retq                     
                                                                                     
.size target, .-target
