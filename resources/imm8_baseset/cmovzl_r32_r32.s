  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text               #  Line  RIP  Bytes  Opcode              
.target:             #        0    0      OPC=<label>         
  movl %ecx, %ecx    #  1     0    2      OPC=movl_r32_r32    
  cmoveq %rcx, %rbx  #  2     0x2  4      OPC=cmoveq_r64_r64  
  retq               #  3     0x6  1      OPC=retq            
                                                              
.size target, .-target
