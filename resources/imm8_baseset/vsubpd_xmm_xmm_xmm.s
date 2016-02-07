  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                         #  Line  RIP   Bytes  Opcode                  
.target:                       #        0     0      OPC=<label>             
  vmovdqu %xmm3, %xmm8         #  1     0     4      OPC=vmovdqu_xmm_xmm     
  vmovdqu %xmm2, %xmm1         #  2     0x4   4      OPC=vmovdqu_xmm_xmm     
  vsubpd %ymm8, %ymm1, %ymm14  #  3     0x8   5      OPC=vsubpd_ymm_ymm_ymm  
  movups %xmm14, %xmm1         #  4     0xd   4      OPC=movups_xmm_xmm      
  retq                         #  5     0x11  1      OPC=retq                
                                                                             
.size target, .-target
