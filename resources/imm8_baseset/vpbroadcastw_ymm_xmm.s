  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                #  Line  RIP   Bytes  Opcode                    
.target:                              #        0     0      OPC=<label>               
  vmovlhps %xmm2, %xmm2, %xmm1        #  1     0     4      OPC=vmovlhps_xmm_xmm_xmm  
  callq .move_byte_1_of_ymm1_to_r9b   #  2     0x4   5      OPC=callq_label           
  callq .move_r9b_to_byte_3_of_ymm1   #  3     0x9   5      OPC=callq_label           
  callq .move_128_064_xmm1_r8_r9      #  4     0xe   5      OPC=callq_label           
  callq .move_r9b_to_byte_14_of_ymm1  #  5     0x13  5      OPC=callq_label           
  callq .move_r9b_to_byte_2_of_ymm1   #  6     0x18  5      OPC=callq_label           
  callq .move_r8b_to_byte_22_of_ymm1  #  7     0x1d  5      OPC=callq_label           
  callq .move_r9b_to_byte_18_of_ymm1  #  8     0x22  5      OPC=callq_label           
  vbroadcastss %xmm1, %ymm1           #  9     0x27  5      OPC=vbroadcastss_ymm_xmm  
  retq                                #  10    0x2c  1      OPC=retq                  
                                                                                      
.size target, .-target
