  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                 #  Line  RIP   Bytes  Opcode                     
.target:                               #        0     0      OPC=<label>                
  vmovsd %xmm3, %xmm2, %xmm1           #  1     0     4      OPC=vmovsd_xmm_xmm_xmm     
  callq .move_128_64_xmm2_xmm10_xmm11  #  2     0x4   5      OPC=callq_label            
  vunpcklpd %xmm11, %xmm10, %xmm14     #  3     0x9   5      OPC=vunpcklpd_xmm_xmm_xmm  
  vminpd %ymm1, %ymm14, %ymm14         #  4     0xe   4      OPC=vminpd_ymm_ymm_ymm     
  vmovaps %xmm14, %xmm1                #  5     0x12  5      OPC=vmovaps_xmm_xmm        
  retq                                 #  6     0x17  1      OPC=retq                   
                                                                                        
.size target, .-target
