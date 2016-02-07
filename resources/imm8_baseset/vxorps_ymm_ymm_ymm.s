  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                  #  Line  RIP   Bytes  Opcode            
.target:                                #        0     0      OPC=<label>       
  callq .move_256_128_ymm2_xmm10_xmm11  #  1     0     5      OPC=callq_label   
  callq .move_256_128_ymm3_xmm8_xmm9    #  2     0x5   5      OPC=callq_label   
  pxor %xmm11, %xmm9                    #  3     0xa   5      OPC=pxor_xmm_xmm  
  callq .move_128_256_xmm8_xmm9_ymm1    #  4     0xf   5      OPC=callq_label   
  pxor %xmm10, %xmm1                    #  5     0x14  5      OPC=pxor_xmm_xmm  
  retq                                  #  6     0x19  1      OPC=retq          
                                                                                
.size target, .-target
