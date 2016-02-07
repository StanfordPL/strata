  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                            #  Line  RIP   Bytes  Opcode                    
.target:                                          #        0     0      OPC=<label>               
  callq .move_128_032_xmm2_xmm8_xmm9_xmm10_xmm11  #  1     0     5      OPC=callq_label           
  vmovaps %xmm2, %xmm9                            #  2     0x5   4      OPC=vmovaps_xmm_xmm       
  callq .move_032_128_xmm8_xmm9_xmm10_xmm11_xmm1  #  3     0x9   5      OPC=callq_label           
  vpbroadcastq %xmm1, %xmm1                       #  4     0xe   5      OPC=vpbroadcastq_xmm_xmm  
  retq                                            #  5     0x13  1      OPC=retq                  
                                                                                                  
.size target, .-target
