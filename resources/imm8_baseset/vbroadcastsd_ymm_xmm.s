  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                #  Line  RIP   Bytes  Opcode               
.target:                              #        0     0      OPC=<label>          
  callq .move_128_064_xmm2_r12_r13    #  1     0     5      OPC=callq_label      
  movq %r12, %r13                     #  2     0x5   3      OPC=movq_r64_r64     
  vzeroall                            #  3     0x8   3      OPC=vzeroall         
  callq .move_064_128_r12_r13_xmm2    #  4     0xb   5      OPC=callq_label      
  vmovdqa %xmm2, %xmm9                #  5     0x10  4      OPC=vmovdqa_xmm_xmm  
  callq .move_128_256_xmm8_xmm9_ymm1  #  6     0x14  5      OPC=callq_label      
  callq .move_064_128_r12_r13_xmm1    #  7     0x19  5      OPC=callq_label      
  retq                                #  8     0x1e  1      OPC=retq             
                                                                                 
.size target, .-target
