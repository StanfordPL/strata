  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                 #  Line  RIP   Bytes  Opcode               
.target:               #        0     0      OPC=<label>          
  movzwq %cx, %rbx     #  1     0     4      OPC=movzwq_r64_r16   
  popcntl %ebx, %r12d  #  2     0x4   5      OPC=popcntl_r32_r32  
  movswq %r12w, %rbx   #  3     0x9   4      OPC=movswq_r64_r16   
  popcntq %r12, %r8    #  4     0xd   5      OPC=popcntq_r64_r64  
  retq                 #  5     0x12  1      OPC=retq             
                                                                  
.size target, .-target
