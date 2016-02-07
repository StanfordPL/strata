  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                        #  Line  RIP   Bytes  Opcode                  
.target:                      #        0     0      OPC=<label>             
  vmovsd %xmm2, %xmm2, %xmm8  #  1     0     4      OPC=vmovsd_xmm_xmm_xmm  
  vmovups %ymm8, %ymm10       #  2     0x4   5      OPC=vmovups_ymm_ymm     
  vxorpd %xmm1, %xmm8, %xmm4  #  3     0x9   4      OPC=vxorpd_xmm_xmm_xmm  
  andnps %xmm10, %xmm4        #  4     0xd   4      OPC=andnps_xmm_xmm      
  movaps %xmm4, %xmm1         #  5     0x11  3      OPC=movaps_xmm_xmm      
  retq                        #  6     0x14  1      OPC=retq                
                                                                            
.size target, .-target
