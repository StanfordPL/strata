  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                          #  Line  RIP   Bytes  Opcode                      
.target:                                        #        0     0      OPC=<label>                 
  vpmovzxwq %xmm2, %xmm8                        #  1     0     5      OPC=vpmovzxwq_xmm_xmm       
  callq .move_128_032_xmm2_xmm4_xmm5_xmm6_xmm7  #  2     0x5   5      OPC=callq_label             
  vpmovzxwq %xmm5, %xmm1                        #  3     0xa   5      OPC=vpmovzxwq_xmm_xmm       
  vunpckhps %ymm1, %ymm8, %ymm0                 #  4     0xf   4      OPC=vunpckhps_ymm_ymm_ymm   
  vpunpckldq %xmm1, %xmm8, %xmm8                #  5     0x13  4      OPC=vpunpckldq_xmm_xmm_xmm  
  vpunpckldq %ymm0, %ymm8, %ymm1                #  6     0x17  4      OPC=vpunpckldq_ymm_ymm_ymm  
  retq                                          #  7     0x1b  1      OPC=retq                    
                                                                                                  
.size target, .-target
