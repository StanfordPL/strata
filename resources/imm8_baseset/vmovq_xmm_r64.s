  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                               #  Line  RIP   Bytes  Opcode             
.target:                             #        0     0      OPC=<label>        
  callq .move_064_032_rbx_r8d_r9d    #  1     0     5      OPC=callq_label    
  vmovd %ebx, %xmm1                  #  2     0x5   4      OPC=vmovd_xmm_r32  
  callq .move_byte_5_of_rbx_to_r8b   #  3     0x9   5      OPC=callq_label    
  callq .move_r9b_to_byte_4_of_ymm1  #  4     0xe   5      OPC=callq_label    
  callq .move_r8b_to_byte_5_of_ymm1  #  5     0x13  5      OPC=callq_label    
  callq .move_byte_6_of_rbx_to_r8b   #  6     0x18  5      OPC=callq_label    
  callq .move_r8b_to_byte_6_of_ymm1  #  7     0x1d  5      OPC=callq_label    
  callq .move_byte_7_of_rbx_to_r9b   #  8     0x22  5      OPC=callq_label    
  callq .move_r9b_to_byte_7_of_ymm1  #  9     0x27  5      OPC=callq_label    
  retq                               #  10    0x2c  1      OPC=retq           
                                                                              
.size target, .-target
