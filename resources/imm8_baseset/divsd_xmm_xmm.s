  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                 #  Line  RIP   Bytes  Opcode                  
.target:                               #        0     0      OPC=<label>             
  vmovapd %xmm2, %xmm4                 #  1     0     4      OPC=vmovapd_xmm_xmm     
  vmovdqu %xmm1, %xmm7                 #  2     0x4   4      OPC=vmovdqu_xmm_xmm     
  callq .move_128_64_xmm1_xmm10_xmm11  #  3     0x8   5      OPC=callq_label         
  vdivpd %ymm4, %ymm7, %ymm10          #  4     0xd   4      OPC=vdivpd_ymm_ymm_ymm  
  callq .move_64_128_xmm10_xmm11_xmm1  #  5     0x11  5      OPC=callq_label         
  retq                                 #  6     0x16  1      OPC=retq                
                                                                                     
.size target, .-target
