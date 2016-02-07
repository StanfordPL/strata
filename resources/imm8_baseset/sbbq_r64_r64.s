  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                    #  Line  RIP  Bytes  Opcode            
.target:                  #        0    0      OPC=<label>       
  notq %rbx               #  1     0    3      OPC=notq_r64      
  adcq %rcx, %rbx         #  2     0x3  3      OPC=adcq_r64_r64  
  notq %rbx               #  3     0x6  3      OPC=notq_r64      
  callq .set_szp_for_rbx  #  4     0x9  5      OPC=callq_label   
  retq                    #  5     0xe  1      OPC=retq          
                                                                 
.size target, .-target
