  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                                 #  Line  RIP   Bytes  Opcode                  
.target:                               #        0     0      OPC=<label>             
  vmovupd %xmm2, %xmm12                #  1     0     4      OPC=vmovupd_xmm_xmm     
  vmovupd %xmm1, %xmm7                 #  2     0x4   4      OPC=vmovupd_xmm_xmm     
  vmaxps %ymm12, %ymm7, %ymm2          #  3     0x8   5      OPC=vmaxps_ymm_ymm_ymm  
  callq .move_128_64_xmm2_xmm10_xmm11  #  4     0xd   5      OPC=callq_label         
  callq .move_64_128_xmm10_xmm11_xmm1  #  5     0x12  5      OPC=callq_label         
  retq                                 #  6     0x17  1      OPC=retq                
                                                                                     
.size target, .-target
