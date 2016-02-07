  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                              #  Line  RIP   Bytes  Opcode                       
.target:                            #        0     0      OPC=<label>                  
  vmovddup %ymm3, %ymm11            #  1     0     4      OPC=vmovddup_ymm_ymm         
  vpunpckhqdq %ymm2, %ymm2, %ymm13  #  2     0x4   4      OPC=vpunpckhqdq_ymm_ymm_ymm  
  vpunpckldq %ymm13, %ymm2, %ymm9   #  3     0x8   5      OPC=vpunpckldq_ymm_ymm_ymm   
  vunpckhps %ymm3, %ymm11, %ymm14   #  4     0xd   4      OPC=vunpckhps_ymm_ymm_ymm    
  vunpcklpd %ymm14, %ymm9, %ymm7    #  5     0x11  5      OPC=vunpcklpd_ymm_ymm_ymm    
  vunpckhpd %ymm14, %ymm9, %ymm12   #  6     0x16  5      OPC=vunpckhpd_ymm_ymm_ymm    
  vsubps %ymm12, %ymm7, %ymm1       #  7     0x1b  5      OPC=vsubps_ymm_ymm_ymm       
  retq                              #  8     0x20  1      OPC=retq                     
                                                                                       
.size target, .-target
