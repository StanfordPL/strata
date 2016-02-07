  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                 #  Line  RIP   Bytes  Opcode                       
.target:                               #        0     0      OPC=<label>                  
  callq .move_128_64_xmm2_xmm10_xmm11  #  1     0     5      OPC=callq_label              
  vunpcklps %xmm11, %xmm10, %xmm12     #  2     0x5   5      OPC=vunpcklps_xmm_xmm_xmm    
  vunpcklpd %xmm3, %xmm12, %xmm5       #  3     0xa   4      OPC=vunpcklpd_xmm_xmm_xmm    
  vpunpckhdq %xmm3, %xmm5, %xmm15      #  4     0xe   4      OPC=vpunpckhdq_xmm_xmm_xmm   
  movlhps %xmm15, %xmm5                #  5     0x12  4      OPC=movlhps_xmm_xmm          
  vpunpckhqdq %xmm15, %xmm12, %xmm3    #  6     0x16  5      OPC=vpunpckhqdq_xmm_xmm_xmm  
  vaddps %xmm3, %xmm5, %xmm1           #  7     0x1b  4      OPC=vaddps_xmm_xmm_xmm       
  retq                                 #  8     0x1f  1      OPC=retq                     
                                                                                          
.size target, .-target
