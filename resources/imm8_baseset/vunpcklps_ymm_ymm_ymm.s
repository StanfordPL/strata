  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                            #  Line  RIP  Bytes  Opcode                      
.target:                          #        0    0      OPC=<label>                 
  vpunpckldq %ymm3, %ymm2, %ymm8  #  1     0    4      OPC=vpunpckldq_ymm_ymm_ymm  
  vmovups %ymm8, %ymm1            #  2     0x4  5      OPC=vmovups_ymm_ymm         
  retq                            #  3     0x9  1      OPC=retq                    
                                                                                   
.size target, .-target
