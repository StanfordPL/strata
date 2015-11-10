  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP   Bytes  Opcode               
.target:                            #        0     0      OPC=<label>          
  callq .read_cf_into_rcx           #  1     0     5      OPC=callq_label      
  popcntq %rcx, %rbx                #  2     0x5   5      OPC=popcntq_r64_r64  
  roll $0x1, %ebx                   #  3     0xa   2      OPC=roll_r32_one     
  sete %bl                          #  4     0xc   3      OPC=sete_r8          
  callq .move_032_016_ecx_r8w_r9w   #  5     0xf   5      OPC=callq_label      
  callq .move_r8b_to_byte_3_of_rbx  #  6     0x14  5      OPC=callq_label      
  retq                              #  7     0x19  1      OPC=retq             
                                                                               
.size target, .-target
