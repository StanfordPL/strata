  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                #  Line  RIP   Bytes  Opcode                      
.target:                              #        0     0      OPC=<label>                 
  vpunpckldq %xmm2, %xmm2, %xmm1      #  1     0     4      OPC=vpunpckldq_xmm_xmm_xmm  
  callq .move_byte_4_of_ymm1_to_r8b   #  2     0x4   5      OPC=callq_label             
  callq .move_byte_5_of_ymm1_to_r9b   #  3     0x9   5      OPC=callq_label             
  callq .move_r9b_to_byte_3_of_ymm1   #  4     0xe   5      OPC=callq_label             
  callq .move_byte_24_of_ymm1_to_r9b  #  5     0x13  5      OPC=callq_label             
  callq .move_r8b_to_byte_2_of_ymm1   #  6     0x18  5      OPC=callq_label             
  callq .move_r9b_to_byte_11_of_ymm1  #  7     0x1d  5      OPC=callq_label             
  vbroadcastss %xmm1, %xmm1           #  8     0x22  5      OPC=vbroadcastss_xmm_xmm    
  retq                                #  9     0x27  1      OPC=retq                    
                                                                                        
.size target, .-target
