  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                             #  Line  RIP   Bytes  Opcode               
.target:                           #        0     0      OPC=<label>          
  movq $0xffffffffffffffc0, %rbx   #  1     0     10     OPC=movq_r64_imm64   
  salq %cl, %rbx                   #  2     0xa   3      OPC=salq_r64_cl      
  callq .move_032_016_ecx_r8w_r9w  #  3     0xd   5      OPC=callq_label      
  callq .move_016_032_r8w_r9w_ebx  #  4     0x12  5      OPC=callq_label      
  popcntq %rbx, %rbx               #  5     0x17  5      OPC=popcntq_r64_r64  
  retq                             #  6     0x1c  1      OPC=retq             
                                                                              
.size target, .-target
