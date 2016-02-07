  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                              #  Line  RIP  Bytes  Opcode            
.target:                            #        0    0      OPC=<label>       
  callq .move_128_064_xmm1_r10_r11  #  1     0    5      OPC=callq_label   
  movq %r10, %rbx                   #  2     0x5  3      OPC=movq_r64_r64  
  retq                              #  3     0x8  1      OPC=retq          
                                                                           
.size target, .-target
