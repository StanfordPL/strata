  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                            #  Line  RIP   Bytes  Opcode                    
.target:                                          #        0     0      OPC=<label>               
  callq .move_128_032_xmm2_xmm8_xmm9_xmm10_xmm11  #  1     0     5      OPC=callq_label           
  vbroadcastss %xmm8, %xmm1                       #  2     0x5   5      OPC=vbroadcastss_xmm_xmm  
  callq .move_256_128_ymm1_xmm8_xmm9              #  3     0xa   5      OPC=callq_label           
  vpbroadcastd %xmm10, %xmm9                      #  4     0xf   5      OPC=vpbroadcastd_xmm_xmm  
  callq .move_64_128_xmm8_xmm9_xmm1               #  5     0x14  5      OPC=callq_label           
  retq                                            #  6     0x19  1      OPC=retq                  
                                                                                                  
.size target, .-target
