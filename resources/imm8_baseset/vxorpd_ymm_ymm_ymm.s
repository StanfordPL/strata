  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                        #  Line  RIP  Bytes  Opcode                 
.target:                      #        0    0      OPC=<label>            
  vpxor %ymm3, %ymm2, %ymm14  #  1     0    4      OPC=vpxor_ymm_ymm_ymm  
  vmovdqa %ymm14, %ymm1       #  2     0x4  5      OPC=vmovdqa_ymm_ymm    
  movupd %xmm14, %xmm1        #  3     0x9  5      OPC=movupd_xmm_xmm     
  retq                        #  4     0xe  1      OPC=retq               
                                                                          
.size target, .-target
