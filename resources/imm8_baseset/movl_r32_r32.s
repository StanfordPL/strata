  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                               #  Line  RIP   Bytes  Opcode              
.target:                             #        0     0      OPC=<label>         
  movq $0x6, %rbx                    #  1     0     10     OPC=movq_r64_imm64  
  callq .move_032_016_ecx_r12w_r13w  #  2     0xa   5      OPC=callq_label     
  callq .move_016_032_r12w_r13w_ebx  #  3     0xf   5      OPC=callq_label     
  retq                               #  4     0x14  1      OPC=retq            
                                                                               
.size target, .-target
