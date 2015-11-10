  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                     #  Line  RIP  Bytes  Opcode            
.target:                   #        0    0      OPC=<label>       
  callq .read_pf_into_rbx  #  1     0    5      OPC=callq_label   
  movw %bx, %bx            #  2     0x5  3      OPC=movw_r16_r16  
  retq                     #  3     0x8  1      OPC=retq          
                                                                  
.size target, .-target
