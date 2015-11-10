  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text               #  Line  RIP  Bytes  Opcode              
.target:             #        0    0      OPC=<label>         
  movzwl %cx, %r13d  #  1     0    4      OPC=movzwl_r32_r16  
  cmovaw %r13w, %bx  #  2     0x4  5      OPC=cmovaw_r16_r16  
  retq               #  3     0x9  1      OPC=retq            
                                                              
.size target, .-target
