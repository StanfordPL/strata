  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP   Bytes  Opcode               
.target:                            #        0     0      OPC=<label>          
  callq .read_pf_into_rbx           #  1     0     5      OPC=callq_label      
  popcntq %rbx, %rcx                #  2     0x5   5      OPC=popcntq_r64_r64  
  callq .read_sf_into_rcx           #  3     0xa   5      OPC=callq_label      
  callq .move_016_008_cx_r8b_r9b    #  4     0xf   5      OPC=callq_label      
  sete %bl                          #  5     0x14  3      OPC=sete_r8          
  callq .move_r9b_to_byte_2_of_rbx  #  6     0x17  5      OPC=callq_label      
  retq                              #  7     0x1c  1      OPC=retq             
                                                                               
.size target, .-target
