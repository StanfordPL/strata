  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                             #  Line  RIP  Bytes  Opcode              
.target:                           #        0    0      OPC=<label>         
  movswq %ax, %rbx                 #  1     0    4      OPC=movswq_r64_r16  
  callq .move_032_016_ebx_r8w_r9w  #  2     0x4  5      OPC=callq_label     
  movzwq %r9w, %rdx                #  3     0x9  4      OPC=movzwq_r64_r16  
  retq                             #  4     0xd  1      OPC=retq            
                                                                            
.size target, .-target
