  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP   Bytes  Opcode            
.target:                            #        0     0      OPC=<label>       
  callq .read_sf_into_rbx           #  1     0     5      OPC=callq_label   
  callq .read_of_into_rcx           #  2     0x5   5      OPC=callq_label   
  xorq %rcx, %rbx                   #  3     0xa   3      OPC=xorq_r64_r64  
  callq .move_byte_7_of_rbx_to_r8b  #  4     0xd   5      OPC=callq_label   
  callq .move_r8b_to_byte_2_of_rbx  #  5     0x12  5      OPC=callq_label   
  retq                              #  6     0x17  1      OPC=retq          
                                                                            
.size target, .-target
