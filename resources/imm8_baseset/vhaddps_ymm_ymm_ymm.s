  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                             #  Line  RIP   Bytes  Opcode                      
.target:                           #        0     0      OPC=<label>                 
  vunpckhps %ymm3, %ymm2, %ymm12   #  1     0     4      OPC=vunpckhps_ymm_ymm_ymm   
  vpunpckldq %ymm3, %ymm2, %ymm7   #  2     0x4   4      OPC=vpunpckldq_ymm_ymm_ymm  
  vunpckhps %ymm12, %ymm7, %ymm10  #  3     0x8   5      OPC=vunpckhps_ymm_ymm_ymm   
  vunpcklps %ymm12, %ymm7, %ymm1   #  4     0xd   5      OPC=vunpcklps_ymm_ymm_ymm   
  vmovdqa %ymm1, %ymm13            #  5     0x12  4      OPC=vmovdqa_ymm_ymm         
  vaddps %ymm10, %ymm13, %ymm1     #  6     0x16  5      OPC=vaddps_ymm_ymm_ymm      
  retq                             #  7     0x1b  1      OPC=retq                    
                                                                                     
.size target, .-target
