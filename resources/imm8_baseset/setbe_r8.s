  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP   Bytes  Opcode              
.target:                            #        0     0      OPC=<label>         
  callq .set_of                     #  1     0     5      OPC=callq_label     
  callq .read_cf_into_rbx           #  2     0x5   5      OPC=callq_label     
  callq .read_of_into_rcx           #  3     0xa   5      OPC=callq_label     
  cmoveq %rcx, %rbx                 #  4     0xf   4      OPC=cmoveq_r64_r64  
  callq .move_byte_7_of_rbx_to_r9b  #  5     0x13  5      OPC=callq_label     
  callq .move_r9b_to_byte_6_of_rbx  #  6     0x18  5      OPC=callq_label     
  retq                              #  7     0x1d  1      OPC=retq            
                                                                              
.size target, .-target
