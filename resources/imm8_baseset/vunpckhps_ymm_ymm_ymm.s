  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                  #  Line  RIP   Bytes  Opcode                       
.target:                                #        0     0      OPC=<label>                  
  vpunpckhqdq %ymm2, %ymm2, %ymm1       #  1     0     4      OPC=vpunpckhqdq_ymm_ymm_ymm  
  vsqrtpd %ymm3, %ymm13                 #  2     0x4   4      OPC=vsqrtpd_ymm_ymm          
  callq .move_256_128_ymm2_xmm12_xmm13  #  3     0x8   5      OPC=callq_label              
  vpunpckhqdq %ymm13, %ymm3, %ymm12     #  4     0xd   5      OPC=vpunpckhqdq_ymm_ymm_ymm  
  vpunpckldq %ymm12, %ymm1, %ymm1       #  5     0x12  5      OPC=vpunpckldq_ymm_ymm_ymm   
  retq                                  #  6     0x17  1      OPC=retq                     
                                                                                           
.size target, .-target
