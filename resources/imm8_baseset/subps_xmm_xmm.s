  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                                #  Line  RIP   Bytes  Opcode                  
.target:                              #        0     0      OPC=<label>             
  vmovaps %xmm1, %xmm9                #  1     0     4      OPC=vmovaps_xmm_xmm     
  vmovups %xmm2, %xmm4                #  2     0x4   4      OPC=vmovups_xmm_xmm     
  vsubps %ymm4, %ymm9, %ymm8          #  3     0x8   4      OPC=vsubps_ymm_ymm_ymm  
  callq .move_128_256_xmm8_xmm9_ymm3  #  4     0xc   5      OPC=callq_label         
  callq .move_128_64_xmm3_xmm8_xmm9   #  5     0x11  5      OPC=callq_label         
  callq .move_64_128_xmm8_xmm9_xmm1   #  6     0x16  5      OPC=callq_label         
  retq                                #  7     0x1b  1      OPC=retq                
                                                                                    
.size target, .-target
