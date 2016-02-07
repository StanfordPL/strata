  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                       #  Line  RIP  Bytes  Opcode                 
.target:                     #        0    0      OPC=<label>            
  vpand %xmm2, %xmm2, %xmm9  #  1     0    4      OPC=vpand_xmm_xmm_xmm  
  vcvtps2dq %ymm9, %ymm11    #  2     0x4  5      OPC=vcvtps2dq_ymm_ymm  
  vmovaps %xmm11, %xmm1      #  3     0x9  5      OPC=vmovaps_xmm_xmm    
  retq                       #  4     0xe  1      OPC=retq               
                                                                         
.size target, .-target
