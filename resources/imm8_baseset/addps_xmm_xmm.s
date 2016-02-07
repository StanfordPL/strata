  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                        #  Line  RIP   Bytes  Opcode                  
.target:                      #        0     0      OPC=<label>             
  vmovdqu %xmm1, %xmm0        #  1     0     4      OPC=vmovdqu_xmm_xmm     
  vmovupd %xmm2, %xmm9        #  2     0x4   4      OPC=vmovupd_xmm_xmm     
  vaddps %ymm9, %ymm0, %ymm6  #  3     0x8   5      OPC=vaddps_ymm_ymm_ymm  
  movdqa %xmm6, %xmm1         #  4     0xd   4      OPC=movdqa_xmm_xmm      
  retq                        #  5     0x11  1      OPC=retq                
                                                                            
.size target, .-target
