  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    2 bytes

# Text                               #  Line  RIP   Bytes  Opcode              
.target:                             #        0     0      OPC=<label>         
  movslq %eax, %rcx                  #  1     0     3      OPC=movslq_r64_r32  
  callq .move_064_032_rcx_r10d_r11d  #  2     0x3   5      OPC=callq_label     
  xchgl %r11d, %r10d                 #  3     0x8   3      OPC=xchgl_r32_r32   
  callq .move_032_064_r10d_r11d_rdx  #  4     0xb   5      OPC=callq_label     
  retq                               #  5     0x10  1      OPC=retq            
                                                                               
.size target, .-target
