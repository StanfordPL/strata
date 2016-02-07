  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text            #  Line  RIP  Bytes  Opcode            
.target:          #        0    0      OPC=<label>       
  cwtl            #  1     0    1      OPC=cwtl          
  cwtl            #  2     0x1  1      OPC=cwtl          
  xchgw %ax, %bx  #  3     0x2  2      OPC=xchgw_r16_ax  
  retq            #  4     0x4  1      OPC=retq          
                                                         
.size target, .-target
