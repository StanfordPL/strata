  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                  #  Line  RIP   Bytes  Opcode                 
.target:                                #        0     0      OPC=<label>            
  callq .move_256_128_ymm2_xmm12_xmm13  #  1     0     5      OPC=callq_label        
  vmovshdup %xmm13, %xmm13              #  2     0x5   5      OPC=vmovshdup_xmm_xmm  
  callq .move_128_256_xmm12_xmm13_ymm1  #  3     0xa   5      OPC=callq_label        
  movshdup %xmm2, %xmm1                 #  4     0xf   4      OPC=movshdup_xmm_xmm   
  retq                                  #  5     0x13  1      OPC=retq               
                                                                                     
.size target, .-target
