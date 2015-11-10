  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text               #  Line  RIP  Bytes  Opcode              
.target:             #        0    0      OPC=<label>         
  cmpl %ebx, %eax    #  1     0    2      OPC=cmpl_r32_r32    
  movl %ebx, %eax    #  2     0x2  2      OPC=movl_r32_r32    
  cmovel %ecx, %ebx  #  3     0x4  3      OPC=cmovel_r32_r32  
  retq               #  4     0x7  1      OPC=retq            
                                                              
.size target, .-target
