  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                  #  Line  RIP   Bytes  Opcode               
.target:                                #        0     0      OPC=<label>          
  callq .move_256_128_ymm2_xmm10_xmm11  #  1     0     5      OPC=callq_label      
  vmovdqu %xmm11, %xmm10                #  2     0x5   5      OPC=vmovdqu_xmm_xmm  
  callq .move_256_128_ymm2_xmm12_xmm13  #  3     0xa   5      OPC=callq_label      
  vsqrtpd %xmm10, %xmm1                 #  4     0xf   5      OPC=vsqrtpd_xmm_xmm  
  vmovaps %xmm1, %xmm11                 #  5     0x14  4      OPC=vmovaps_xmm_xmm  
  movdqa %xmm11, %xmm13                 #  6     0x18  5      OPC=movdqa_xmm_xmm   
  vsqrtpd %xmm12, %xmm12                #  7     0x1d  5      OPC=vsqrtpd_xmm_xmm  
  callq .move_128_256_xmm12_xmm13_ymm1  #  8     0x22  5      OPC=callq_label      
  retq                                  #  9     0x27  1      OPC=retq             
                                                                                   
.size target, .-target
