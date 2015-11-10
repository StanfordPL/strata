  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                 #  Line  RIP   Bytes  Opcode                       
.target:                               #        0     0      OPC=<label>                  
  vpunpcklqdq %xmm2, %xmm3, %xmm1      #  1     0     4      OPC=vpunpcklqdq_xmm_xmm_xmm  
  unpckhps %xmm3, %xmm2                #  2     0x4   3      OPC=unpckhps_xmm_xmm         
  callq .move_128_64_xmm2_xmm12_xmm13  #  3     0x7   5      OPC=callq_label              
  callq .move_64_128_xmm12_xmm13_xmm1  #  4     0xc   5      OPC=callq_label              
  retq                                 #  5     0x11  1      OPC=retq                     
                                                                                          
.size target, .-target
