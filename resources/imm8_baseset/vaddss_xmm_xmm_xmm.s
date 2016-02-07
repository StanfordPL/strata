  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                         #  Line  RIP  Bytes  Opcode                  
.target:                       #        0    0      OPC=<label>             
  vaddps %xmm3, %xmm2, %xmm11  #  1     0    4      OPC=vaddps_xmm_xmm_xmm  
  vmovss %xmm11, %xmm2, %xmm1  #  2     0x4  5      OPC=vmovss_xmm_xmm_xmm  
  retq                         #  3     0x9  1      OPC=retq                
                                                                            
.size target, .-target
