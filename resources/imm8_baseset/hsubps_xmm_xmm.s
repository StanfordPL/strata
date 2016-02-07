  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                               #  Line  RIP   Bytes  Opcode                       
.target:                             #        0     0      OPC=<label>                  
  callq .move_128_64_xmm2_xmm8_xmm9  #  1     0     5      OPC=callq_label              
  vpunpckhqdq %xmm2, %xmm1, %xmm14   #  2     0x5   4      OPC=vpunpckhqdq_xmm_xmm_xmm  
  vunpcklps %xmm14, %xmm1, %xmm11    #  3     0x9   5      OPC=vunpcklps_xmm_xmm_xmm    
  unpcklps %xmm9, %xmm8              #  4     0xe   4      OPC=unpcklps_xmm_xmm         
  vunpckhpd %xmm8, %xmm11, %xmm14    #  5     0x12  5      OPC=vunpckhpd_xmm_xmm_xmm    
  unpcklpd %xmm8, %xmm11             #  6     0x17  5      OPC=unpcklpd_xmm_xmm         
  vsubps %ymm14, %ymm11, %ymm0       #  7     0x1c  5      OPC=vsubps_ymm_ymm_ymm       
  movupd %xmm0, %xmm1                #  8     0x21  4      OPC=movupd_xmm_xmm           
  retq                               #  9     0x25  1      OPC=retq                     
                                                                                        
.size target, .-target
