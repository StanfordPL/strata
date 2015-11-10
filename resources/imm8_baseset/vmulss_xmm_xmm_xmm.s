  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                          #  Line  RIP   Bytes  Opcode                       
.target:                                        #        0     0      OPC=<label>                  
  callq .move_128_032_xmm2_xmm4_xmm5_xmm6_xmm7  #  1     0     5      OPC=callq_label              
  callq .move_032_128_xmm4_xmm5_xmm6_xmm7_xmm1  #  2     0x5   5      OPC=callq_label              
  punpckhqdq %xmm1, %xmm7                       #  3     0xa   4      OPC=punpckhqdq_xmm_xmm       
  vfmsub132ss %xmm3, %xmm7, %xmm1               #  4     0xe   5      OPC=vfmsub132ss_xmm_xmm_xmm  
  retq                                          #  5     0x13  1      OPC=retq                     
                                                                                                   
.size target, .-target
