  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                  #  Line  RIP   Bytes  Opcode                    
.target:                                #        0     0      OPC=<label>               
  callq .move_256_128_ymm2_xmm10_xmm11  #  1     0     5      OPC=callq_label           
  vpbroadcastq %xmm11, %ymm1            #  2     0x5   5      OPC=vpbroadcastq_ymm_xmm  
  vpbroadcastq %xmm2, %xmm5             #  3     0xa   5      OPC=vpbroadcastq_xmm_xmm  
  movdqu %xmm5, %xmm1                   #  4     0xf   4      OPC=movdqu_xmm_xmm        
  retq                                  #  5     0x13  1      OPC=retq                  
                                                                                        
.size target, .-target
