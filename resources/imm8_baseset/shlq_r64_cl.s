  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP   Bytes  Opcode             
.target:                            #        0     0      OPC=<label>        
  callq .move_byte_6_of_rbx_to_r9b  #  1     0     5      OPC=callq_label    
  callq .move_r9b_to_byte_6_of_rbx  #  2     0x5   5      OPC=callq_label    
  movq %rbx, %r8                    #  3     0xa   3      OPC=movq_r64_r64   
  xchgw %r8w, %bx                   #  4     0xd   4      OPC=xchgw_r16_r16  
  salq %cl, %rbx                    #  5     0x11  3      OPC=salq_r64_cl    
  retq                              #  6     0x14  1      OPC=retq           
                                                                             
.size target, .-target
