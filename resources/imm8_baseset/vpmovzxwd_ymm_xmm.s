  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                  #  Line  RIP   Bytes  Opcode                  
.target:                                #        0     0      OPC=<label>             
  callq .move_128_64_xmm2_xmm10_xmm11   #  1     0     5      OPC=callq_label         
  vpmovzxwd %xmm11, %xmm4               #  2     0x5   5      OPC=vpmovzxwd_xmm_xmm   
  vmaxpd %xmm4, %xmm4, %xmm11           #  3     0xa   4      OPC=vmaxpd_xmm_xmm_xmm  
  callq .move_128_256_xmm10_xmm11_ymm1  #  4     0xe   5      OPC=callq_label         
  pmovzxwd %xmm10, %xmm1                #  5     0x13  6      OPC=pmovzxwd_xmm_xmm    
  retq                                  #  6     0x19  1      OPC=retq                
                                                                                      
.size target, .-target
