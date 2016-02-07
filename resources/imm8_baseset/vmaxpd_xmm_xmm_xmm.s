  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                 #  Line  RIP   Bytes  Opcode                  
.target:                               #        0     0      OPC=<label>             
  vmovupd %xmm3, %xmm1                 #  1     0     4      OPC=vmovupd_xmm_xmm     
  callq .move_128_64_xmm1_xmm12_xmm13  #  2     0x4   5      OPC=callq_label         
  vmovsd %xmm12, %xmm3, %xmm5          #  3     0x9   5      OPC=vmovsd_xmm_xmm_xmm  
  vmovdqa %xmm2, %xmm11                #  4     0xe   4      OPC=vmovdqa_xmm_xmm     
  vmaxpd %ymm5, %ymm11, %ymm1          #  5     0x12  4      OPC=vmaxpd_ymm_ymm_ymm  
  retq                                 #  6     0x16  1      OPC=retq                
                                                                                     
.size target, .-target
