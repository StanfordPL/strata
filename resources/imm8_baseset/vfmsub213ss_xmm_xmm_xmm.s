  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                          #  Line  RIP  Bytes  Opcode                       
.target:                                        #        0    0      OPC=<label>                  
  callq .move_128_032_xmm1_xmm4_xmm5_xmm6_xmm7  #  1     0    5      OPC=callq_label              
  movss %xmm2, %xmm1                            #  2     0x5  4      OPC=movss_xmm_xmm            
  vfmsub132ss %xmm4, %xmm3, %xmm1               #  3     0x9  5      OPC=vfmsub132ss_xmm_xmm_xmm  
  retq                                          #  4     0xe  1      OPC=retq                     
                                                                                                  
.size target, .-target
