  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                               #  Line  RIP   Bytes  Opcode              
.target:                             #        0     0      OPC=<label>         
  movq $0x10, %rbx                   #  1     0     10     OPC=movq_r64_imm64  
  movsbq %cl, %rdx                   #  2     0xa   4      OPC=movsbq_r64_r8   
  callq .move_032_016_edx_r10w_r11w  #  3     0xe   5      OPC=callq_label     
  callq .move_016_032_r10w_r11w_ebx  #  4     0x13  5      OPC=callq_label     
  retq                               #  5     0x18  1      OPC=retq            
                                                                               
.size target, .-target
