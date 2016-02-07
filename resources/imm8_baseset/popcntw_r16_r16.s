  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                #  Line  RIP  Bytes  Opcode               
.target:              #        0    0      OPC=<label>          
  movzwq %cx, %r12    #  1     0    4      OPC=movzwq_r64_r16   
  popcntq %r12, %rbx  #  2     0x4  5      OPC=popcntq_r64_r64  
  retq                #  3     0x9  1      OPC=retq             
                                                                
.size target, .-target
