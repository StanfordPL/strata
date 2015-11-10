  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                            #  Line  RIP   Bytes  Opcode                    
.target:                                          #        0     0      OPC=<label>               
  callq .move_128_032_xmm2_xmm8_xmm9_xmm10_xmm11  #  1     0     5      OPC=callq_label           
  vrcpss %xmm9, %xmm9, %xmm5                      #  2     0x5   5      OPC=vrcpss_xmm_xmm_xmm    
  vrcpss %xmm11, %xmm8, %xmm7                     #  3     0xa   5      OPC=vrcpss_xmm_xmm_xmm    
  vmovsldup %xmm7, %xmm1                          #  4     0xf   4      OPC=vmovsldup_xmm_xmm     
  vbroadcastss %xmm5, %ymm6                       #  5     0x13  5      OPC=vbroadcastss_ymm_xmm  
  rcpss %xmm10, %xmm1                             #  6     0x18  5      OPC=rcpss_xmm_xmm         
  unpcklpd %xmm1, %xmm1                           #  7     0x1d  4      OPC=unpcklpd_xmm_xmm      
  vrcpss %xmm2, %xmm6, %xmm10                     #  8     0x21  4      OPC=vrcpss_xmm_xmm_xmm    
  vmovlhps %xmm1, %xmm10, %xmm1                   #  9     0x25  4      OPC=vmovlhps_xmm_xmm_xmm  
  retq                                            #  10    0x29  1      OPC=retq                  
                                                                                                  
.size target, .-target
