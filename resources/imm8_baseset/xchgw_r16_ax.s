  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                             #  Line  RIP   Bytes  Opcode              
.target:                           #        0     0      OPC=<label>         
  movzwq %ax, %rdx                 #  1     0     4      OPC=movzwq_r64_r16  
  movswq %bx, %rax                 #  2     0x4   4      OPC=movswq_r64_r16  
  callq .move_064_032_rdx_r8d_r9d  #  3     0x8   5      OPC=callq_label     
  callq .move_016_032_r8w_r9w_ebx  #  4     0xd   5      OPC=callq_label     
  retq                             #  5     0x12  1      OPC=retq            
                                                                             
.size target, .-target
