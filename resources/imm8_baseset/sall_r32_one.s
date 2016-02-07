  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text              #  Line  RIP  Bytes  Opcode             
.target:            #        0    0      OPC=<label>        
  xorl %eax, %eax   #  1     0    2      OPC=xorl_r32_r32   
  movl %ebx, %r9d   #  2     0x2  3      OPC=movl_r32_r32   
  xchgl %r9d, %eax  #  3     0x5  3      OPC=xchgl_r32_r32  
  shll $0x1, %eax   #  4     0x8  2      OPC=shll_r32_one   
  xchgl %ebx, %eax  #  5     0xa  1      OPC=xchgl_eax_r32  
  retq              #  6     0xb  1      OPC=retq           
                                                            
.size target, .-target
