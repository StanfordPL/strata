  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                            #  Line  RIP   Bytes  Opcode                    
.target:                                          #        0     0      OPC=<label>               
  callq .move_128_032_xmm2_xmm8_xmm9_xmm10_xmm11  #  1     0     5      OPC=callq_label           
  vpbroadcastq %xmm11, %ymm11                     #  2     0x5   5      OPC=vpbroadcastq_ymm_xmm  
  movss %xmm10, %xmm11                            #  3     0xa   5      OPC=movss_xmm_xmm         
  callq .move_128_256_xmm10_xmm11_ymm1            #  4     0xf   5      OPC=callq_label           
  callq .move_64_128_xmm8_xmm9_xmm1               #  5     0x14  5      OPC=callq_label           
  retq                                            #  6     0x19  1      OPC=retq                  
                                                                                                  
.size target, .-target
