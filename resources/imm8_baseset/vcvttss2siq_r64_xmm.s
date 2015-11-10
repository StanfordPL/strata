  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                 #  Line  RIP  Bytes  Opcode                  
.target:                               #        0    0      OPC=<label>             
  callq .move_128_64_xmm1_xmm12_xmm13  #  1     0    5      OPC=callq_label         
  cvttss2siq %xmm12, %rbx              #  2     0x5  5      OPC=cvttss2siq_r64_xmm  
  retq                                 #  3     0xa  1      OPC=retq                
                                                                                    
.size target, .-target
