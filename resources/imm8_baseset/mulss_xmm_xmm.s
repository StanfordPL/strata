  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                         #  Line  RIP   Bytes  Opcode                  
.target:                       #        0     0      OPC=<label>             
  vmovups %xmm1, %xmm14        #  1     0     4      OPC=vmovups_xmm_xmm     
  vmovdqa %xmm2, %xmm3         #  2     0x4   4      OPC=vmovdqa_xmm_xmm     
  vmulps %ymm3, %ymm14, %ymm8  #  3     0x8   4      OPC=vmulps_ymm_ymm_ymm  
  movss %xmm8, %xmm1           #  4     0xc   5      OPC=movss_xmm_xmm       
  retq                         #  5     0x11  1      OPC=retq                
                                                                             
.size target, .-target
