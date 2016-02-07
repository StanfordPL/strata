  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                          #  Line  RIP   Bytes  Opcode                 
.target:                                        #        0     0      OPC=<label>            
  vpmovzxwq %xmm2, %xmm2                        #  1     0     5      OPC=vpmovzxwq_xmm_xmm  
  callq .move_128_032_xmm2_xmm4_xmm5_xmm6_xmm7  #  2     0x5   5      OPC=callq_label        
  vpmovzxbq %xmm2, %xmm1                        #  3     0xa   5      OPC=vpmovzxbq_xmm_xmm  
  vpmovzxbq %xmm6, %xmm7                        #  4     0xf   5      OPC=vpmovzxbq_xmm_xmm  
  hsubps %xmm7, %xmm1                           #  5     0x14  4      OPC=hsubps_xmm_xmm     
  retq                                          #  6     0x18  1      OPC=retq               
                                                                                             
.size target, .-target
