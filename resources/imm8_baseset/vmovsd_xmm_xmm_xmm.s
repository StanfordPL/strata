  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                 #  Line  RIP   Bytes  Opcode                  
.target:                               #        0     0      OPC=<label>             
  callq .move_128_64_xmm2_xmm12_xmm13  #  1     0     5      OPC=callq_label         
  punpcklqdq %xmm13, %xmm3             #  2     0x5   5      OPC=punpcklqdq_xmm_xmm  
  callq .move_128_064_xmm3_r8_r9       #  3     0xa   5      OPC=callq_label         
  vzeroall                             #  4     0xf   3      OPC=vzeroall            
  callq .move_064_128_r8_r9_xmm1       #  5     0x12  5      OPC=callq_label         
  retq                                 #  6     0x17  1      OPC=retq                
                                                                                     
.size target, .-target
