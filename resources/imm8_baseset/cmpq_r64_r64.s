  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text             #  Line  RIP  Bytes  Opcode            
.target:           #        0    0      OPC=<label>       
  callq .clear_cf  #  1     0    5      OPC=callq_label   
  sbbq %rcx, %rbx  #  2     0x5  3      OPC=sbbq_r64_r64  
  retq             #  3     0x8  1      OPC=retq          
                                                          
.size target, .-target
