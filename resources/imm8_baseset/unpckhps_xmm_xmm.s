  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                                            #  Line  RIP   Bytes  Opcode                     
.target:                                          #        0     0      OPC=<label>                
  callq .move_128_032_xmm2_xmm4_xmm5_xmm6_xmm7    #  1     0     5      OPC=callq_label            
  callq .move_128_032_xmm1_xmm8_xmm9_xmm10_xmm11  #  2     0x5   5      OPC=callq_label            
  vmovdqu %xmm11, %xmm6                           #  3     0xa   5      OPC=vmovdqu_xmm_xmm        
  callq .move_128_64_xmm2_xmm8_xmm9               #  4     0xf   5      OPC=callq_label            
  vunpcklpd %xmm11, %xmm10, %xmm4                 #  5     0x14  5      OPC=vunpcklpd_xmm_xmm_xmm  
  vmovaps %xmm9, %xmm5                            #  6     0x19  5      OPC=vmovaps_xmm_xmm        
  callq .move_032_128_xmm4_xmm5_xmm6_xmm7_xmm1    #  7     0x1e  5      OPC=callq_label            
  retq                                            #  8     0x23  1      OPC=retq                   
                                                                                                   
.size target, .-target
