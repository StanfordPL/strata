  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                              #  Line  RIP   Bytes  Opcode                       
.target:                            #        0     0      OPC=<label>                  
  vmovaps %xmm2, %xmm7              #  1     0     4      OPC=vmovaps_xmm_xmm          
  vmovaps %xmm1, %xmm11             #  2     0x4   4      OPC=vmovaps_xmm_xmm          
  movss %xmm7, %xmm11               #  3     0x8   5      OPC=movss_xmm_xmm            
  vbroadcastss %xmm1, %ymm2         #  4     0xd   5      OPC=vbroadcastss_ymm_xmm     
  vfmsub132ss %xmm2, %xmm3, %xmm11  #  5     0x12  5      OPC=vfmsub132ss_xmm_xmm_xmm  
  vmovdqa %ymm11, %ymm1             #  6     0x17  5      OPC=vmovdqa_ymm_ymm          
  retq                              #  7     0x1c  1      OPC=retq                     
                                                                                       
.size target, .-target
