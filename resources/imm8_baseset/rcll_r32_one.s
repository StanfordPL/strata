  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text             #  Line  RIP  Bytes  Opcode            
.target:           #        0    0      OPC=<label>       
  movl %ebx, %eax  #  1     0    2      OPC=movl_r32_r32  
  adcl %eax, %eax  #  2     0x2  2      OPC=adcl_r32_r32  
  movq %rax, %rbx  #  3     0x4  3      OPC=movq_r64_r64  
  retq             #  4     0x7  1      OPC=retq          
                                                          
.size target, .-target
