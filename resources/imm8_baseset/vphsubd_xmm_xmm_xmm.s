  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                            #  Line  RIP   Bytes  Opcode                       
.target:                                          #        0     0      OPC=<label>                  
  callq .move_128_032_xmm2_xmm8_xmm9_xmm10_xmm11  #  1     0     5      OPC=callq_label              
  psubq %xmm9, %xmm8                              #  2     0x5   5      OPC=psubq_xmm_xmm            
  vmovsldup %xmm3, %xmm1                          #  3     0xa   4      OPC=vmovsldup_xmm_xmm        
  vpsubq %xmm3, %xmm1, %xmm0                      #  4     0xe   4      OPC=vpsubq_xmm_xmm_xmm       
  phaddd %xmm9, %xmm0                             #  5     0x12  6      OPC=phaddd_xmm_xmm           
  vpsubq %xmm11, %xmm10, %xmm9                    #  6     0x18  5      OPC=vpsubq_xmm_xmm_xmm       
  callq .move_032_128_xmm8_xmm9_xmm10_xmm11_xmm3  #  7     0x1d  5      OPC=callq_label              
  vpunpcklqdq %xmm0, %xmm3, %xmm1                 #  8     0x22  4      OPC=vpunpcklqdq_xmm_xmm_xmm  
  retq                                            #  9     0x26  1      OPC=retq                     
                                                                                                     
.size target, .-target
