  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                  #  Line  RIP   Bytes  Opcode                     
.target:                                #        0     0      OPC=<label>                
  callq .move_256_128_ymm3_xmm10_xmm11  #  1     0     5      OPC=callq_label            
  callq .move_128_256_xmm10_xmm11_ymm1  #  2     0x5   5      OPC=callq_label            
  punpckhqdq %xmm1, %xmm2               #  3     0xa   4      OPC=punpckhqdq_xmm_xmm     
  callq .move_256_128_ymm2_xmm12_xmm13  #  4     0xe   5      OPC=callq_label            
  vunpckhpd %xmm11, %xmm13, %xmm13      #  5     0x13  5      OPC=vunpckhpd_xmm_xmm_xmm  
  callq .move_128_256_xmm12_xmm13_ymm1  #  6     0x18  5      OPC=callq_label            
  retq                                  #  7     0x1d  1      OPC=retq                   
                                                                                         
.size target, .-target
