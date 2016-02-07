  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                               #  Line  RIP  Bytes  Opcode            
.target:                             #        0    0      OPC=<label>       
  callq .move_064_032_rcx_r12d_r13d  #  1     0    5      OPC=callq_label   
  movq %rbx, %rcx                    #  2     0x5  3      OPC=movq_r64_r64  
  callq .move_032_064_r12d_r13d_rbx  #  3     0x8  5      OPC=callq_label   
  retq                               #  4     0xd  1      OPC=retq          
                                                                            
.size target, .-target
