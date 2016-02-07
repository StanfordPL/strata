  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                     #  Line  RIP   Bytes  Opcode            
.target:                   #        0     0      OPC=<label>       
  movl %ebx, %r13d         #  1     0     3      OPC=movl_r32_r32  
  movl %ecx, %r8d          #  2     0x3   3      OPC=movl_r32_r32  
  xorq %r8, %r13           #  3     0x6   3      OPC=xorq_r64_r64  
  callq .read_sf_into_rbx  #  4     0x9   5      OPC=callq_label   
  adcl %r13d, %ebx         #  5     0xe   3      OPC=adcl_r32_r32  
  retq                     #  6     0x11  1      OPC=retq          
                                                                   
.size target, .-target
