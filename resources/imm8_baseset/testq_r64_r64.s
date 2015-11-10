  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                    #  Line  RIP  Bytes  Opcode                 
.target:                  #        0    0      OPC=<label>            
  andnq %rcx, %rbx, %r14  #  1     0    5      OPC=andnq_r64_r64_r64  
  subq %r14, %rcx         #  2     0x5  3      OPC=subq_r64_r64       
  callq .clear_of         #  3     0x8  5      OPC=callq_label        
  retq                    #  4     0xd  1      OPC=retq               
                                                                      
.size target, .-target
