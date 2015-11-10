  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text              #  Line  RIP  Bytes  Opcode            
.target:            #        0    0      OPC=<label>       
  movl %ebx, %r11d  #  1     0    3      OPC=movl_r32_r32  
  movq %r11, %xmm1  #  2     0x3  5      OPC=movq_xmm_r64  
  retq              #  3     0x8  1      OPC=retq          
                                                           
.size target, .-target
