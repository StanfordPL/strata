  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                              #  Line  RIP   Bytes  Opcode                 
.target:                            #        0     0      OPC=<label>            
  callq .move_128_064_xmm2_r12_r13  #  1     0     5      OPC=callq_label        
  callq .move_064_128_r12_r13_xmm1  #  2     0x5   5      OPC=callq_label        
  vcvtps2pd %xmm1, %ymm1            #  3     0xa   4      OPC=vcvtps2pd_ymm_xmm  
  vmovdqa %xmm1, %xmm1              #  4     0xe   4      OPC=vmovdqa_xmm_xmm    
  retq                              #  5     0x12  1      OPC=retq               
                                                                                 
.size target, .-target
