  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                              #  Line  RIP   Bytes  Opcode               
.target:                            #        0     0      OPC=<label>          
  andpd %xmm2, %xmm3                #  1     0     4      OPC=andpd_xmm_xmm    
  callq .move_128_064_xmm3_r12_r13  #  2     0x4   5      OPC=callq_label      
  callq .move_064_128_r12_r13_xmm2  #  3     0x9   5      OPC=callq_label      
  vmovdqa %xmm2, %xmm1              #  4     0xe   4      OPC=vmovdqa_xmm_xmm  
  retq                              #  5     0x12  1      OPC=retq             
                                                                               
.size target, .-target
