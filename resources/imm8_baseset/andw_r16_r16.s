  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text              #  Line  RIP  Bytes  Opcode              
.target:            #        0    0      OPC=<label>         
  movswl %cx, %eax  #  1     0    3      OPC=movswl_r32_r16  
  movswq %bx, %r12  #  2     0x3  4      OPC=movswq_r64_r16  
  andl %r12d, %eax  #  3     0x7  3      OPC=andl_r32_r32    
  movw %ax, %bx     #  4     0xa  3      OPC=movw_r16_r16    
  retq              #  5     0xd  1      OPC=retq            
                                                             
.size target, .-target
