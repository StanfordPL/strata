  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text               #  Line  RIP  Bytes  Opcode              
.target:             #        0    0      OPC=<label>         
  bswap %eax         #  1     0    2      OPC=bswap_r32       
  bswap %eax         #  2     0x2  2      OPC=bswap_r32       
  movslq %eax, %rax  #  3     0x4  3      OPC=movslq_r64_r32  
  retq               #  4     0x7  1      OPC=retq            
                                                              
.size target, .-target
