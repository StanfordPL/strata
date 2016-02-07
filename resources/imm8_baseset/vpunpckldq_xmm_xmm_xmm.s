  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                            #  Line  RIP   Bytes  Opcode                    
.target:                                          #        0     0      OPC=<label>               
  callq .move_128_032_xmm3_xmm4_xmm5_xmm6_xmm7    #  1     0     5      OPC=callq_label           
  callq .move_128_64_xmm2_xmm8_xmm9               #  2     0x5   5      OPC=callq_label           
  vmovdqa %xmm8, %xmm1                            #  3     0xa   5      OPC=vmovdqa_xmm_xmm       
  vpbroadcastq %xmm4, %ymm9                       #  4     0xf   5      OPC=vpbroadcastq_ymm_xmm  
  vmovshdup %xmm1, %xmm10                         #  5     0x14  4      OPC=vmovshdup_xmm_xmm     
  movdqa %xmm5, %xmm11                            #  6     0x18  5      OPC=movdqa_xmm_xmm        
  callq .move_032_128_xmm8_xmm9_xmm10_xmm11_xmm1  #  7     0x1d  5      OPC=callq_label           
  retq                                            #  8     0x22  1      OPC=retq                  
                                                                                                  
.size target, .-target
