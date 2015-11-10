  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                               #  Line  RIP   Bytes  Opcode                  
.target:                             #        0     0      OPC=<label>             
  callq .move_128_64_xmm1_xmm8_xmm9  #  1     0     5      OPC=callq_label         
  callq .move_64_128_xmm8_xmm9_xmm3  #  2     0x5   5      OPC=callq_label         
  vxorps %xmm3, %xmm2, %xmm4         #  3     0xa   4      OPC=vxorps_xmm_xmm_xmm  
  movdqa %xmm4, %xmm1                #  4     0xe   4      OPC=movdqa_xmm_xmm      
  retq                               #  5     0x12  1      OPC=retq                
                                                                                   
.size target, .-target
