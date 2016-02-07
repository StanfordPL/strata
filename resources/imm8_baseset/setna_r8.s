  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP   Bytes  Opcode             
.target:                            #        0     0      OPC=<label>        
  callq .read_cf_into_rbx           #  1     0     5      OPC=callq_label    
  setbe %r12b                       #  2     0x5   4      OPC=setbe_r8       
  movsbl %bl, %r13d                 #  3     0x9   4      OPC=movsbl_r32_r8  
  callq .move_byte_5_of_rbx_to_r9b  #  4     0xd   5      OPC=callq_label    
  callq .move_008_016_r12b_r13b_bx  #  5     0x12  5      OPC=callq_label    
  callq .move_r9b_to_byte_6_of_rbx  #  6     0x17  5      OPC=callq_label    
  callq .move_r9b_to_byte_7_of_rbx  #  7     0x1c  5      OPC=callq_label    
  retq                              #  8     0x21  1      OPC=retq           
                                                                             
.size target, .-target
