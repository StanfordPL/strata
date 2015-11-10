  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                              #  Line  RIP   Bytes  Opcode              
.target:                            #        0     0      OPC=<label>         
  movq $0x0, %r11                   #  1     0     10     OPC=movq_r64_imm64  
  movq %rbx, %r10                   #  2     0xa   3      OPC=movq_r64_r64    
  callq .move_064_128_r10_r11_xmm1  #  3     0xd   5      OPC=callq_label     
  retq                              #  4     0x12  1      OPC=retq            
                                                                              
.size target, .-target
