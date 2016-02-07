  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                               #  Line  RIP   Bytes  Opcode                    
.target:                             #        0     0      OPC=<label>               
  callq .move_128_064_xmm2_r8_r9     #  1     0     5      OPC=callq_label           
  vzeroall                           #  2     0x5   3      OPC=vzeroall              
  callq .move_r8b_to_byte_7_of_ymm1  #  3     0x8   5      OPC=callq_label           
  callq .move_r8b_to_byte_6_of_ymm1  #  4     0xd   5      OPC=callq_label           
  callq .move_byte_6_of_ymm1_to_r9b  #  5     0x12  5      OPC=callq_label           
  callq .move_r8b_to_byte_5_of_ymm1  #  6     0x17  5      OPC=callq_label           
  callq .move_r9b_to_byte_4_of_ymm1  #  7     0x1c  5      OPC=callq_label           
  vmovshdup %xmm1, %xmm1             #  8     0x21  4      OPC=vmovshdup_xmm_xmm     
  vpbroadcastq %xmm1, %xmm1          #  9     0x25  5      OPC=vpbroadcastq_xmm_xmm  
  retq                               #  10    0x2a  1      OPC=retq                  
                                                                                     
.size target, .-target
