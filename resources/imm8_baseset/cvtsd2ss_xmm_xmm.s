  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                         #  Line  RIP   Bytes  Opcode                  
.target:                       #        0     0      OPC=<label>             
  vmovaps %xmm2, %xmm2         #  1     0     4      OPC=vmovaps_xmm_xmm     
  vcvtpd2ps %ymm2, %xmm7       #  2     0x4   4      OPC=vcvtpd2ps_xmm_ymm   
  vminpd %ymm7, %ymm7, %ymm10  #  3     0x8   4      OPC=vminpd_ymm_ymm_ymm  
  movss %xmm10, %xmm1          #  4     0xc   5      OPC=movss_xmm_xmm       
  retq                         #  5     0x11  1      OPC=retq                
                                                                             
.size target, .-target
