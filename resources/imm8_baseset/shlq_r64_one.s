  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP   Bytes  Opcode            
.target:                            #        0     0      OPC=<label>       
  xorq %rax, %rax                   #  1     0     3      OPC=xorq_r64_r64  
  adcq %rbx, %rbx                   #  2     0x3   3      OPC=adcq_r64_r64  
  callq .move_byte_5_of_rbx_to_r8b  #  3     0x6   5      OPC=callq_label   
  callq .move_r8b_to_byte_5_of_rbx  #  4     0xb   5      OPC=callq_label   
  retq                              #  5     0x10  1      OPC=retq          
                                                                            
.size target, .-target
