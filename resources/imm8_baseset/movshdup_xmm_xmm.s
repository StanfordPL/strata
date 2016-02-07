  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                            #  Line  RIP   Bytes  Opcode                 
.target:                                          #        0     0      OPC=<label>            
  callq .move_128_032_xmm2_xmm8_xmm9_xmm10_xmm11  #  1     0     5      OPC=callq_label        
  vpmovzxdq %xmm9, %xmm10                         #  2     0x5   5      OPC=vpmovzxdq_xmm_xmm  
  callq .move_64_128_xmm10_xmm11_xmm1             #  3     0xa   5      OPC=callq_label        
  vmovsldup %xmm1, %xmm14                         #  4     0xf   4      OPC=vmovsldup_xmm_xmm  
  movdqa %xmm14, %xmm1                            #  5     0x13  5      OPC=movdqa_xmm_xmm     
  retq                                            #  6     0x18  1      OPC=retq               
                                                                                               
.size target, .-target
