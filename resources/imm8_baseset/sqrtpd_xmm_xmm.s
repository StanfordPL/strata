  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                  #  Line  RIP  Bytes  Opcode               
.target:                #        0    0      OPC=<label>          
  vmovupd %xmm2, %xmm4  #  1     0    4      OPC=vmovupd_xmm_xmm  
  vsqrtpd %ymm4, %ymm4  #  2     0x4  4      OPC=vsqrtpd_ymm_ymm  
  movups %xmm4, %xmm1   #  3     0x8  3      OPC=movups_xmm_xmm   
  retq                  #  4     0xb  1      OPC=retq             
                                                                  
.size target, .-target
