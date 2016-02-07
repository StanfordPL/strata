  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                          #  Line  RIP   Bytes  Opcode                  
.target:                        #        0     0      OPC=<label>             
  vmovdqu %xmm2, %xmm10         #  1     0     4      OPC=vmovdqu_xmm_xmm     
  vmovapd %xmm1, %xmm5          #  2     0x4   4      OPC=vmovapd_xmm_xmm     
  vdivpd %ymm10, %ymm5, %ymm10  #  3     0x8   5      OPC=vdivpd_ymm_ymm_ymm  
  movdqa %xmm10, %xmm1          #  4     0xd   5      OPC=movdqa_xmm_xmm      
  retq                          #  5     0x12  1      OPC=retq                
                                                                              
.size target, .-target
