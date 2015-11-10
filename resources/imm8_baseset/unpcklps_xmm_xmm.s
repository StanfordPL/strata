  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                        #  Line  RIP  Bytes  Opcode                    
.target:                      #        0    0      OPC=<label>               
  punpcklqdq %xmm1, %xmm1     #  1     0    4      OPC=punpcklqdq_xmm_xmm    
  vpbroadcastq %xmm2, %xmm13  #  2     0x4  5      OPC=vpbroadcastq_xmm_xmm  
  unpckhps %xmm13, %xmm1      #  3     0x9  4      OPC=unpckhps_xmm_xmm      
  retq                        #  4     0xd  1      OPC=retq                  
                                                                             
.size target, .-target
