  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                              #  Line  RIP  Bytes  Opcode             
.target:                            #        0    0      OPC=<label>        
  callq .move_128_064_xmm1_r12_r13  #  1     0    5      OPC=callq_label    
  xaddq %r13, %r12                  #  2     0x5  4      OPC=xaddq_r64_r64  
  movq %r13, %rbx                   #  3     0x9  3      OPC=movq_r64_r64   
  retq                              #  4     0xc  1      OPC=retq           
                                                                            
.size target, .-target
