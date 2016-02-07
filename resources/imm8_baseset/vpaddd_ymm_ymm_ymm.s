  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                             #  Line  RIP   Bytes  Opcode                      
.target:                           #        0     0      OPC=<label>                 
  vpunpckldq %ymm3, %ymm2, %ymm5   #  1     0     4      OPC=vpunpckldq_ymm_ymm_ymm  
  vpunpckhdq %ymm2, %ymm3, %ymm13  #  2     0x4   4      OPC=vpunpckhdq_ymm_ymm_ymm  
  vphaddd %ymm13, %ymm5, %ymm8     #  3     0x8   5      OPC=vphaddd_ymm_ymm_ymm     
  vmovdqu %ymm8, %ymm1             #  4     0xd   5      OPC=vmovdqu_ymm_ymm         
  retq                             #  5     0x12  1      OPC=retq                    
                                                                                     
.size target, .-target
