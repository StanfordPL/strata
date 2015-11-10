  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                  #  Line  RIP  Bytes  Opcode               
.target:                #        0    0      OPC=<label>          
  vmovdqa %ymm2, %ymm1  #  1     0    4      OPC=vmovdqa_ymm_ymm  
  movapd %xmm2, %xmm1   #  2     0x4  4      OPC=movapd_xmm_xmm   
  retq                  #  3     0x8  1      OPC=retq             
                                                                  
.size target, .-target
