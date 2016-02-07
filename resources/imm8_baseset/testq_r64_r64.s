  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text             #  Line  RIP  Bytes  Opcode            
.target:           #        0    0      OPC=<label>       
  andq %rbx, %rcx  #  1     0    3      OPC=andq_r64_r64  
  callq .clear_of  #  2     0x3  5      OPC=callq_label   
  retq             #  3     0x8  1      OPC=retq          
                                                          
.size target, .-target
