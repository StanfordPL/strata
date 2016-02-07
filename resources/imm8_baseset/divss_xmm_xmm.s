  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                            #  Line  RIP   Bytes  Opcode                     
.target:                          #        0     0      OPC=<label>                
  vmovupd %xmm2, %xmm7            #  1     0     4      OPC=vmovupd_xmm_xmm        
  vunpcklpd %xmm7, %xmm1, %xmm15  #  2     0x4   4      OPC=vunpcklpd_xmm_xmm_xmm  
  vdivps %ymm7, %ymm15, %ymm13    #  3     0x8   4      OPC=vdivps_ymm_ymm_ymm     
  movss %xmm13, %xmm1             #  4     0xc   5      OPC=movss_xmm_xmm          
  retq                            #  5     0x11  1      OPC=retq                   
                                                                                   
.size target, .-target
