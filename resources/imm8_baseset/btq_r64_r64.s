  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text             #  Line  RIP  Bytes  Opcode            
.target:           #        0    0      OPC=<label>       
  notq %rcx        #  1     0    3      OPC=notq_r64      
  salq %cl, %rbx   #  2     0x3  3      OPC=salq_r64_cl   
  salq $0x1, %rbx  #  3     0x6  3      OPC=salq_r64_one  
  retq             #  4     0x9  1      OPC=retq          
                                                          
.size target, .-target
