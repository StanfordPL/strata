  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                          #  Line  RIP   Bytes  Opcode                    
.target:                                        #        0     0      OPC=<label>               
  callq .move_128_032_xmm2_xmm4_xmm5_xmm6_xmm7  #  1     0     5      OPC=callq_label           
  vpbroadcastd %xmm5, %xmm1                     #  2     0x5   5      OPC=vpbroadcastd_xmm_xmm  
  vpbroadcastd %xmm7, %xmm6                     #  3     0xa   5      OPC=vpbroadcastd_xmm_xmm  
  punpckhqdq %xmm6, %xmm1                       #  4     0xf   4      OPC=punpckhqdq_xmm_xmm    
  retq                                          #  5     0x13  1      OPC=retq                  
                                                                                                
.size target, .-target
