  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                              #  Line  RIP   Bytes  Opcode                 
.target:                            #        0     0      OPC=<label>            
  callq .move_128_064_xmm2_r10_r11  #  1     0     5      OPC=callq_label        
  callq .move_128_064_xmm3_r12_r13  #  2     0x5   5      OPC=callq_label        
  vcvtdq2pd %xmm2, %xmm1            #  3     0xa   4      OPC=vcvtdq2pd_xmm_xmm  
  orq %r10, %r12                    #  4     0xe   3      OPC=orq_r64_r64        
  orq %r11, %r13                    #  5     0x11  3      OPC=orq_r64_r64        
  callq .move_064_128_r12_r13_xmm1  #  6     0x14  5      OPC=callq_label        
  retq                              #  7     0x19  1      OPC=retq               
                                                                                 
.size target, .-target
