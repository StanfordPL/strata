  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                     #  Line  RIP  Bytes  Opcode               
.target:                   #        0    0      OPC=<label>          
  callq .read_cf_into_rbx  #  1     0    5      OPC=callq_label      
  popcntq %rbx, %r9        #  2     0x5  5      OPC=popcntq_r64_r64  
  setz %ah                 #  3     0xa  3      OPC=setz_rh          
  retq                     #  4     0xd  1      OPC=retq             
                                                                     
.size target, .-target
