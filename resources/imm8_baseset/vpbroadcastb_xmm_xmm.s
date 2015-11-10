  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                       #  Line  RIP   Bytes  Opcode                    
.target:                     #        0     0      OPC=<label>               
  vpmovzxdq %xmm2, %ymm2     #  1     0     5      OPC=vpmovzxdq_ymm_xmm     
  vpmovzxbq %xmm2, %xmm1     #  2     0x5   5      OPC=vpmovzxbq_xmm_xmm     
  vpbroadcastb %xmm1, %ymm6  #  3     0xa   5      OPC=vpbroadcastb_ymm_xmm  
  vbroadcastss %xmm6, %xmm1  #  4     0xf   5      OPC=vbroadcastss_xmm_xmm  
  retq                       #  5     0x14  1      OPC=retq                  
                                                                             
.size target, .-target
