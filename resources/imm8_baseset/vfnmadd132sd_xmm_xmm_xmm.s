  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                 #  Line  RIP   Bytes  Opcode                        
.target:                               #        0     0      OPC=<label>                   
  callq .move_128_64_xmm3_xmm8_xmm9    #  1     0     5      OPC=callq_label               
  callq .move_128_64_xmm2_xmm12_xmm13  #  2     0x5   5      OPC=callq_label               
  vfnmadd231pd %xmm8, %xmm1, %xmm12    #  3     0xa   5      OPC=vfnmadd231pd_xmm_xmm_xmm  
  vrcpss %xmm13, %xmm1, %xmm10         #  4     0xf   5      OPC=vrcpss_xmm_xmm_xmm        
  vmovsd %xmm12, %xmm10, %xmm1         #  5     0x14  5      OPC=vmovsd_xmm_xmm_xmm        
  retq                                 #  6     0x19  1      OPC=retq                      
                                                                                           
.size target, .-target
