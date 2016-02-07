  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                #  Line  RIP   Bytes  Opcode                    
.target:                              #        0     0      OPC=<label>               
  callq .move_128_064_xmm2_r8_r9      #  1     0     5      OPC=callq_label           
  movsbl %r8b, %r8d                   #  2     0x5   4      OPC=movsbl_r32_r8         
  callq .move_064_128_r8_r9_xmm3      #  3     0x9   5      OPC=callq_label           
  vpmovzxdq %xmm3, %xmm1              #  4     0xe   5      OPC=vpmovzxdq_xmm_xmm     
  callq .move_r8b_to_byte_2_of_ymm1   #  5     0x13  5      OPC=callq_label           
  callq .move_r8b_to_byte_16_of_ymm1  #  6     0x18  5      OPC=callq_label           
  callq .move_r8b_to_byte_3_of_ymm1   #  7     0x1d  5      OPC=callq_label           
  callq .move_r8b_to_byte_1_of_ymm1   #  8     0x22  5      OPC=callq_label           
  vbroadcastss %xmm1, %ymm1           #  9     0x27  5      OPC=vbroadcastss_ymm_xmm  
  retq                                #  10    0x2c  1      OPC=retq                  
                                                                                      
.size target, .-target
