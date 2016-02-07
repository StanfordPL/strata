  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                              #  Line  RIP  Bytes  Opcode                       
.target:                            #        0    0      OPC=<label>                  
  vunpcklpd %ymm3, %ymm2, %ymm10    #  1     0    4      OPC=vunpcklpd_ymm_ymm_ymm    
  vpunpckhqdq %ymm3, %ymm2, %ymm12  #  2     0x4  4      OPC=vpunpckhqdq_ymm_ymm_ymm  
  vsubpd %ymm12, %ymm10, %ymm1      #  3     0x8  5      OPC=vsubpd_ymm_ymm_ymm       
  retq                              #  4     0xd  1      OPC=retq                     
                                                                                      
.size target, .-target
