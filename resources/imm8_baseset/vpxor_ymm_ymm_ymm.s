  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                        #  Line  RIP  Bytes  Opcode                  
.target:                      #        0    0      OPC=<label>             
  vxorps %ymm3, %ymm2, %ymm1  #  1     0    4      OPC=vxorps_ymm_ymm_ymm  
  vxorps %ymm3, %ymm2, %ymm8  #  2     0x4  4      OPC=vxorps_ymm_ymm_ymm  
  movaps %xmm8, %xmm1         #  3     0x8  4      OPC=movaps_xmm_xmm      
  retq                        #  4     0xc  1      OPC=retq                
                                                                           
.size target, .-target
