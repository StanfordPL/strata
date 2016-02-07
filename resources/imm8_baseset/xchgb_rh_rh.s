  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text             #  Line  RIP  Bytes  Opcode             
.target:           #        0    0      OPC=<label>        
  xorl %esi, %esi  #  1     0    2      OPC=xorl_r32_r32   
  setz %bl         #  2     0x2  3      OPC=setz_r8        
  setp %al         #  3     0x5  3      OPC=setp_r8        
  xchgw %ax, %bx   #  4     0x8  3      OPC=xchgw_r16_r16  
  retq             #  5     0xb  1      OPC=retq           
                                                           
.size target, .-target
