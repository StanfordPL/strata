  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                        #  Line  RIP   Bytes  Opcode                  
.target:                      #        0     0      OPC=<label>             
  vmovapd %xmm3, %xmm0        #  1     0     4      OPC=vmovapd_xmm_xmm     
  vmovdqu %xmm2, %xmm1        #  2     0x4   4      OPC=vmovdqu_xmm_xmm     
  vsubps %ymm0, %ymm1, %ymm3  #  3     0x8   4      OPC=vsubps_ymm_ymm_ymm  
  vmovdqu %xmm3, %xmm1        #  4     0xc   4      OPC=vmovdqu_xmm_xmm     
  retq                        #  5     0x10  1      OPC=retq                
                                                                            
.size target, .-target
