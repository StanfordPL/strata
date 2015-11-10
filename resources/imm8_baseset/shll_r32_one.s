  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text               #  Line  RIP  Bytes  Opcode             
.target:             #        0    0      OPC=<label>        
  movzbl %bl, %r10d  #  1     0    4      OPC=movzbl_r32_r8  
  xaddl %r10d, %ebx  #  2     0x4  4      OPC=xaddl_r32_r32  
  xaddl %ebx, %r10d  #  3     0x8  4      OPC=xaddl_r32_r32  
  addl %ebx, %ebx    #  4     0xc  2      OPC=addl_r32_r32   
  retq               #  5     0xe  1      OPC=retq           
                                                             
.size target, .-target
