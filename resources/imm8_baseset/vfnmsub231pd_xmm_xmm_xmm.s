  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                               #  Line  RIP   Bytes  Opcode                        
.target:                             #        0     0      OPC=<label>                   
  vmovaps %xmm2, %xmm2               #  1     0     4      OPC=vmovaps_xmm_xmm           
  vmovupd %xmm3, %xmm11              #  2     0x4   4      OPC=vmovupd_xmm_xmm           
  vmovups %xmm1, %xmm4               #  3     0x8   4      OPC=vmovups_xmm_xmm           
  vfnmsub231pd %ymm11, %ymm2, %ymm4  #  4     0xc   5      OPC=vfnmsub231pd_ymm_ymm_ymm  
  vmovss %xmm4, %xmm4, %xmm1         #  5     0x11  4      OPC=vmovss_xmm_xmm_xmm        
  retq                               #  6     0x15  1      OPC=retq                      
                                                                                         
.size target, .-target
