  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                     #  Line  RIP   Bytes  Opcode            
.target:                   #        0     0      OPC=<label>       
  callq .read_cf_into_rbx  #  1     0     5      OPC=callq_label   
  movl %ebx, %r10d         #  2     0x5   3      OPC=movl_r32_r32  
  callq .read_zf_into_rbx  #  3     0x8   5      OPC=callq_label   
  orq %r10, %rbx           #  4     0xd   3      OPC=orq_r64_r64   
  retq                     #  5     0x10  1      OPC=retq          
                                                                   
.size target, .-target
