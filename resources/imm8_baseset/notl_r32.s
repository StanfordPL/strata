  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                               #  Line  RIP  Bytes  Opcode            
.target:                             #        0    0      OPC=<label>       
  movl %ebx, %ebx                    #  1     0    2      OPC=movl_r32_r32  
  notq %rbx                          #  2     0x2  3      OPC=notq_r64      
  callq .move_064_032_rbx_r10d_r11d  #  3     0x5  5      OPC=callq_label   
  movl %r10d, %ebx                   #  4     0xa  3      OPC=movl_r32_r32  
  retq                               #  5     0xd  1      OPC=retq          
                                                                            
.size target, .-target
