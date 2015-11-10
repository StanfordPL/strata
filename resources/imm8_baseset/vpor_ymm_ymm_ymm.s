  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                  #  Line  RIP   Bytes  Opcode                
.target:                                #        0     0      OPC=<label>           
  orps %xmm2, %xmm3                     #  1     0     3      OPC=orps_xmm_xmm      
  callq .move_256_128_ymm2_xmm10_xmm11  #  2     0x3   5      OPC=callq_label       
  callq .move_256_128_ymm3_xmm12_xmm13  #  3     0x8   5      OPC=callq_label       
  vpor %xmm13, %xmm11, %xmm13           #  4     0xd   5      OPC=vpor_xmm_xmm_xmm  
  callq .move_128_256_xmm12_xmm13_ymm1  #  5     0x12  5      OPC=callq_label       
  retq                                  #  6     0x17  1      OPC=retq              
                                                                                    
.size target, .-target
