  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                          #  Line  RIP   Bytes  Opcode                       
.target:                                        #        0     0      OPC=<label>                  
  callq .move_128_032_xmm2_xmm4_xmm5_xmm6_xmm7  #  1     0     5      OPC=callq_label              
  paddq %xmm6, %xmm7                            #  2     0x5   4      OPC=paddq_xmm_xmm            
  vmovshdup %xmm1, %xmm13                       #  3     0x9   4      OPC=vmovshdup_xmm_xmm        
  vpaddq %xmm2, %xmm5, %xmm6                    #  4     0xd   4      OPC=vpaddq_xmm_xmm_xmm       
  paddq %xmm1, %xmm13                           #  5     0x11  5      OPC=paddq_xmm_xmm            
  vpunpckhqdq %xmm1, %xmm13, %xmm5              #  6     0x16  4      OPC=vpunpckhqdq_xmm_xmm_xmm  
  vminpd %ymm13, %ymm13, %ymm4                  #  7     0x1a  5      OPC=vminpd_ymm_ymm_ymm       
  callq .move_032_128_xmm4_xmm5_xmm6_xmm7_xmm1  #  8     0x1f  5      OPC=callq_label              
  retq                                          #  9     0x24  1      OPC=retq                     
                                                                                                   
.size target, .-target
