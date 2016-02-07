  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                               #  Line  RIP   Bytes  Opcode                  
.target:                             #        0     0      OPC=<label>             
  vmovdqa %xmm2, %xmm14              #  1     0     4      OPC=vmovdqa_xmm_xmm     
  vmovaps %xmm1, %xmm8               #  2     0x4   4      OPC=vmovaps_xmm_xmm     
  vminps %ymm14, %ymm8, %ymm2        #  3     0x8   5      OPC=vminps_ymm_ymm_ymm  
  callq .move_128_64_xmm2_xmm8_xmm9  #  4     0xd   5      OPC=callq_label         
  callq .move_64_128_xmm8_xmm9_xmm1  #  5     0x12  5      OPC=callq_label         
  retq                               #  6     0x17  1      OPC=retq                
                                                                                   
.size target, .-target
