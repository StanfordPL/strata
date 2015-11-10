  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                  #  Line  RIP   Bytes  Opcode                 
.target:                                #        0     0      OPC=<label>            
  callq .move_256_128_ymm2_xmm10_xmm11  #  1     0     5      OPC=callq_label        
  callq .move_256_128_ymm3_xmm12_xmm13  #  2     0x5   5      OPC=callq_label        
  vorps %xmm2, %xmm3, %xmm10            #  3     0xa   4      OPC=vorps_xmm_xmm_xmm  
  orps %xmm13, %xmm11                   #  4     0xe   4      OPC=orps_xmm_xmm       
  callq .move_128_256_xmm10_xmm11_ymm1  #  5     0x12  5      OPC=callq_label        
  retq                                  #  6     0x17  1      OPC=retq               
                                                                                     
.size target, .-target
