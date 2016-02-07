  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                        #  Line  RIP   Bytes  Opcode                  
.target:                      #        0     0      OPC=<label>             
  vmovdqu %xmm2, %xmm7        #  1     0     4      OPC=vmovdqu_xmm_xmm     
  vmovdqa %xmm1, %xmm4        #  2     0x4   4      OPC=vmovdqa_xmm_xmm     
  vsubpd %ymm7, %ymm4, %ymm0  #  3     0x8   4      OPC=vsubpd_ymm_ymm_ymm  
  movdqa %xmm0, %xmm1         #  4     0xc   4      OPC=movdqa_xmm_xmm      
  retq                        #  5     0x10  1      OPC=retq                
                                                                            
.size target, .-target
