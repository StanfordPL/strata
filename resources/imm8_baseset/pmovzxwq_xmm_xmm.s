  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                     #  Line  RIP  Bytes  Opcode                 
.target:                   #        0    0      OPC=<label>            
  vpmovzxdq %xmm2, %xmm3   #  1     0    5      OPC=vpmovzxdq_xmm_xmm  
  vpmovzxwq %xmm3, %xmm10  #  2     0x5  5      OPC=vpmovzxwq_xmm_xmm  
  movdqu %xmm10, %xmm1     #  3     0xa  5      OPC=movdqu_xmm_xmm     
  retq                     #  4     0xf  1      OPC=retq               
                                                                       
.size target, .-target
