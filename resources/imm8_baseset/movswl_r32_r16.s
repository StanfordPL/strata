  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                               #  Line  RIP   Bytes  Opcode              
.target:                             #        0     0      OPC=<label>         
  movswq %cx, %rdx                   #  1     0     4      OPC=movswq_r64_r16  
  movq $0xffffffffffffffe0, %rbx     #  2     0x4   10     OPC=movq_r64_imm64  
  callq .move_032_016_edx_r10w_r11w  #  3     0xe   5      OPC=callq_label     
  callq .move_016_032_r10w_r11w_ebx  #  4     0x13  5      OPC=callq_label     
  retq                               #  5     0x18  1      OPC=retq            
                                                                               
.size target, .-target
