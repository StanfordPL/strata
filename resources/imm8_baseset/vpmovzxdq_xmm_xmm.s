  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                          #  Line  RIP   Bytes  Opcode                    
.target:                                        #        0     0      OPC=<label>               
  callq .move_128_064_xmm2_r8_r9                #  1     0     5      OPC=callq_label           
  callq .move_128_032_xmm2_xmm4_xmm5_xmm6_xmm7  #  2     0x5   5      OPC=callq_label           
  vmovd %r8d, %xmm2                             #  3     0xa   5      OPC=vmovd_xmm_r32         
  vpbroadcastq %xmm5, %xmm1                     #  4     0xf   5      OPC=vpbroadcastq_xmm_xmm  
  movss %xmm2, %xmm1                            #  5     0x14  4      OPC=movss_xmm_xmm         
  retq                                          #  6     0x18  1      OPC=retq                  
                                                                                                
.size target, .-target
