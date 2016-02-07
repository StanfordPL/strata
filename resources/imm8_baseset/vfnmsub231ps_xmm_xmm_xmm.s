  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                               #  Line  RIP  Bytes  Opcode                        
.target:                             #        0    0      OPC=<label>                   
  movaps %xmm1, %xmm14               #  1     0    4      OPC=movaps_xmm_xmm            
  vfnmsub213ps %xmm14, %xmm2, %xmm3  #  2     0x4  5      OPC=vfnmsub213ps_xmm_xmm_xmm  
  vmovdqu %ymm3, %ymm1               #  3     0x9  4      OPC=vmovdqu_ymm_ymm           
  retq                               #  4     0xd  1      OPC=retq                      
                                                                                        
.size target, .-target
