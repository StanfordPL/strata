  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                            #  Line  RIP   Bytes  Opcode              
.target:                          #        0     0      OPC=<label>         
  movq $0x4, %rbx                 #  1     0     10     OPC=movq_r64_imm64  
  callq .move_016_008_cx_r8b_r9b  #  2     0xa   5      OPC=callq_label     
  callq .move_008_016_r8b_r9b_bx  #  3     0xf   5      OPC=callq_label     
  retq                            #  4     0x14  1      OPC=retq            
                                                                            
.size target, .-target
