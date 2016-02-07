  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                          #  Line  RIP   Bytes  Opcode                    
.target:                                        #        0     0      OPC=<label>               
  vmovddup %xmm2, %xmm12                        #  1     0     4      OPC=vmovddup_xmm_xmm      
  callq .move_128_032_xmm1_xmm4_xmm5_xmm6_xmm7  #  2     0x4   5      OPC=callq_label           
  vpbroadcastq %xmm12, %xmm4                    #  3     0x9   5      OPC=vpbroadcastq_xmm_xmm  
  callq .move_032_128_xmm4_xmm5_xmm6_xmm7_xmm1  #  4     0xe   5      OPC=callq_label           
  retq                                          #  5     0x13  1      OPC=retq                  
                                                                                                
.size target, .-target
