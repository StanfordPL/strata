  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                         #  Line  RIP   Bytes  Opcode                  
.target:                       #        0     0      OPC=<label>             
  vmovdqa %xmm3, %xmm6         #  1     0     4      OPC=vmovdqa_xmm_xmm     
  vmovsd %xmm2, %xmm2, %xmm9   #  2     0x4   4      OPC=vmovsd_xmm_xmm_xmm  
  vmaxps %ymm6, %ymm9, %ymm10  #  3     0x8   4      OPC=vmaxps_ymm_ymm_ymm  
  vmovupd %xmm10, %xmm1        #  4     0xc   5      OPC=vmovupd_xmm_xmm     
  retq                         #  5     0x11  1      OPC=retq                
                                                                             
.size target, .-target
