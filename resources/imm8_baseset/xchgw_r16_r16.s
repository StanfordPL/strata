  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP   Bytes  Opcode              
.target:                            #        0     0      OPC=<label>         
  xorl %r13d, %r13d                 #  1     0     3      OPC=xorl_r32_r32    
  movswl %cx, %r12d                 #  2     0x3   4      OPC=movswl_r32_r16  
  callq .move_064_128_r12_r13_xmm1  #  3     0x7   5      OPC=callq_label     
  callq .move_128_064_xmm1_r8_r9    #  4     0xc   5      OPC=callq_label     
  movzwq %bx, %rcx                  #  5     0x11  4      OPC=movzwq_r64_r16  
  callq .move_032_064_r8d_r9d_rbx   #  6     0x15  5      OPC=callq_label     
  retq                              #  7     0x1a  1      OPC=retq            
                                                                              
.size target, .-target
