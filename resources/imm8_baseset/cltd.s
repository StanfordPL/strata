  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    2 bytes

# Text                             #  Line  RIP  Bytes  Opcode              
.target:                           #        0    0      OPC=<label>         
  movslq %eax, %rdx                #  1     0    3      OPC=movslq_r64_r32  
  callq .move_064_032_rdx_r8d_r9d  #  2     0x3  5      OPC=callq_label     
  cwtd                             #  3     0x8  2      OPC=cwtd            
  xchgl %edx, %r9d                 #  4     0xa  3      OPC=xchgl_r32_r32   
  retq                             #  5     0xd  1      OPC=retq            
                                                                            
.size target, .-target
