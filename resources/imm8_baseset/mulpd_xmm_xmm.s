  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                          #  Line  RIP   Bytes  Opcode                  
.target:                        #        0     0      OPC=<label>             
  vmovdqa %xmm1, %xmm6          #  1     0     4      OPC=vmovdqa_xmm_xmm     
  vmovaps %xmm2, %xmm12         #  2     0x4   4      OPC=vmovaps_xmm_xmm     
  vmulpd %ymm12, %ymm6, %ymm10  #  3     0x8   5      OPC=vmulpd_ymm_ymm_ymm  
  movupd %xmm10, %xmm1          #  4     0xd   5      OPC=movupd_xmm_xmm      
  retq                          #  5     0x12  1      OPC=retq                
                                                                              
.size target, .-target
