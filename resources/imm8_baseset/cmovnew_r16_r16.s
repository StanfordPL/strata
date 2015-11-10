  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text             #  Line  RIP  Bytes  Opcode              
.target:           #        0    0      OPC=<label>         
  xchgw %cx, %bx   #  1     0    3      OPC=xchgw_r16_r16   
  cmovzw %cx, %bx  #  2     0x3  4      OPC=cmovzw_r16_r16  
  retq             #  3     0x7  1      OPC=retq            
                                                            
.size target, .-target
