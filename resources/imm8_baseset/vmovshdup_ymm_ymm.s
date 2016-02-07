  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                  #  Line  RIP   Bytes  Opcode                
.target:                                #        0     0      OPC=<label>           
  callq .move_256_128_ymm2_xmm10_xmm11  #  1     0     5      OPC=callq_label       
  movshdup %xmm11, %xmm8                #  2     0x5   5      OPC=movshdup_xmm_xmm  
  movdqa %xmm8, %xmm9                   #  3     0xa   5      OPC=movdqa_xmm_xmm    
  movshdup %xmm10, %xmm8                #  4     0xf   5      OPC=movshdup_xmm_xmm  
  callq .move_128_256_xmm8_xmm9_ymm1    #  5     0x14  5      OPC=callq_label       
  retq                                  #  6     0x19  1      OPC=retq              
                                                                                    
.size target, .-target
