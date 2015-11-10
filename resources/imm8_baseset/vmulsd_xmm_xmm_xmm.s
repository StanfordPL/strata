  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                #  Line  RIP   Bytes  Opcode                       
.target:                              #        0     0      OPC=<label>                  
  vmovdqa %xmm2, %xmm1                #  1     0     4      OPC=vmovdqa_xmm_xmm          
  callq .move_256_128_ymm1_xmm8_xmm9  #  2     0x4   5      OPC=callq_label              
  vfmsub132sd %xmm3, %xmm9, %xmm8     #  3     0x9   5      OPC=vfmsub132sd_xmm_xmm_xmm  
  callq .move_128_256_xmm8_xmm9_ymm1  #  4     0xe   5      OPC=callq_label              
  retq                                #  5     0x13  1      OPC=retq                     
                                                                                         
.size target, .-target
