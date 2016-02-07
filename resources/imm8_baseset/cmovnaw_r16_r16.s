  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text              #  Line  RIP  Bytes  Opcode              
.target:            #        0    0      OPC=<label>         
  movzwl %cx, %esi  #  1     0    3      OPC=movzwl_r32_r16  
  cmovew %si, %bx   #  2     0x3  4      OPC=cmovew_r16_r16  
  cmovcw %si, %bx   #  3     0x7  4      OPC=cmovcw_r16_r16  
  retq              #  4     0xb  1      OPC=retq            
                                                             
.size target, .-target
