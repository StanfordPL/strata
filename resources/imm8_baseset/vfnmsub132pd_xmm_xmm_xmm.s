  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                              #  Line  RIP  Bytes  Opcode                        
.target:                            #        0    0      OPC=<label>                   
  movdqu %xmm2, %xmm2               #  1     0    4      OPC=movdqu_xmm_xmm            
  vfnmsub231pd %xmm3, %xmm1, %xmm2  #  2     0x4  5      OPC=vfnmsub231pd_xmm_xmm_xmm  
  vmovdqu %ymm2, %ymm1              #  3     0x9  4      OPC=vmovdqu_ymm_ymm           
  retq                              #  4     0xd  1      OPC=retq                      
                                                                                       
.size target, .-target
