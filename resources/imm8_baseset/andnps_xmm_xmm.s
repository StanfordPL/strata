  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                       #  Line  RIP  Bytes  Opcode                 
.target:                     #        0    0      OPC=<label>            
  vorpd %xmm2, %xmm1, %xmm4  #  1     0    4      OPC=vorpd_xmm_xmm_xmm  
  vmovdqu %ymm4, %ymm0       #  2     0x4  4      OPC=vmovdqu_ymm_ymm    
  xorpd %xmm0, %xmm1         #  3     0x8  4      OPC=xorpd_xmm_xmm      
  retq                       #  4     0xc  1      OPC=retq               
                                                                         
.size target, .-target
