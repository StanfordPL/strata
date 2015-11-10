  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP   Bytes  Opcode              
.target:                            #        0     0      OPC=<label>         
  callq .move_016_008_bx_r8b_r9b    #  1     0     5      OPC=callq_label     
  callq .move_008_016_r8b_r9b_dx    #  2     0x5   5      OPC=callq_label     
  movzwl %dx, %ebx                  #  3     0xa   3      OPC=movzwl_r32_r16  
  callq .move_r9b_to_byte_3_of_rbx  #  4     0xd   5      OPC=callq_label     
  shrl $0x1, %ebx                   #  5     0x12  2      OPC=shrl_r32_one    
  movzwq %bx, %rbx                  #  6     0x14  4      OPC=movzwq_r64_r16  
  retq                              #  7     0x18  1      OPC=retq            
                                                                              
.size target, .-target
