  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                 #  Line  RIP   Bytes  Opcode             
.target:                               #        0     0      OPC=<label>        
  callq .move_128_64_xmm3_xmm10_xmm11  #  1     0     5      OPC=callq_label    
  maxss %xmm10, %xmm2                  #  2     0x5   5      OPC=maxss_xmm_xmm  
  callq .move_128_064_xmm2_r12_r13     #  3     0xa   5      OPC=callq_label    
  vzeroall                             #  4     0xf   3      OPC=vzeroall       
  callq .move_064_128_r12_r13_xmm1     #  5     0x12  5      OPC=callq_label    
  retq                                 #  6     0x17  1      OPC=retq           
                                                                                
.size target, .-target
