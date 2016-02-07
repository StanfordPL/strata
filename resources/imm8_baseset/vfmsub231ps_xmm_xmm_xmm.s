  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                               #  Line  RIP   Bytes  Opcode                       
.target:                             #        0     0      OPC=<label>                  
  vmovaps %xmm1, %xmm1               #  1     0     4      OPC=vmovaps_xmm_xmm          
  vaddss %xmm1, %xmm3, %xmm12        #  2     0x4   4      OPC=vaddss_xmm_xmm_xmm       
  movdqu %xmm2, %xmm12               #  3     0x8   5      OPC=movdqu_xmm_xmm           
  vmovupd %xmm3, %xmm14              #  4     0xd   4      OPC=vmovupd_xmm_xmm          
  vfmsub231ps %ymm14, %ymm12, %ymm1  #  5     0x11  5      OPC=vfmsub231ps_ymm_ymm_ymm  
  retq                               #  6     0x16  1      OPC=retq                     
                                                                                        
.size target, .-target
