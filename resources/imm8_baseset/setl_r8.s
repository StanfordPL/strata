  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                     #  Line  RIP  Bytes  Opcode            
.target:                   #        0    0      OPC=<label>       
  callq .read_of_into_rcx  #  1     0    5      OPC=callq_label   
  setnge %cl               #  2     0x5  3      OPC=setnge_r8     
  movl %ecx, %ebx          #  3     0x8  2      OPC=movl_r32_r32  
  retq                     #  4     0xa  1      OPC=retq          
                                                                  
.size target, .-target
