  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                       #  Line  RIP  Bytes  Opcode                 
.target:                     #        0    0      OPC=<label>            
  vorps %ymm2, %ymm3, %ymm9  #  1     0    4      OPC=vorps_ymm_ymm_ymm  
  vpxor %ymm2, %ymm9, %ymm3  #  2     0x4  4      OPC=vpxor_ymm_ymm_ymm  
  vmovups %ymm3, %ymm1       #  3     0x8  4      OPC=vmovups_ymm_ymm    
  retq                       #  4     0xc  1      OPC=retq               
                                                                         
.size target, .-target
