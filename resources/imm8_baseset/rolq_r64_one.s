  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                               #  Line  RIP  Bytes  Opcode             
.target:                             #        0    0      OPC=<label>        
  movq %rbx, %r14                    #  1     0    3      OPC=movq_r64_r64   
  callq .move_064_032_rbx_r10d_r11d  #  2     0x3  5      OPC=callq_label    
  xaddl %r11d, %r11d                 #  3     0x8  4      OPC=xaddl_r32_r32  
  adcq %r14, %rbx                    #  4     0xc  3      OPC=adcq_r64_r64   
  retq                               #  5     0xf  1      OPC=retq           
                                                                             
.size target, .-target
