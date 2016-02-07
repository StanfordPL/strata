  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                #  Line  RIP   Bytes  Opcode                        
.target:                              #        0     0      OPC=<label>                   
  vpsubq %xmm2, %xmm2, %xmm7          #  1     0     4      OPC=vpsubq_xmm_xmm_xmm        
  vorps %xmm3, %xmm3, %xmm10          #  2     0x4   4      OPC=vorps_xmm_xmm_xmm         
  vfnmsub132ps %ymm10, %ymm10, %ymm7  #  3     0x8   5      OPC=vfnmsub132ps_ymm_ymm_ymm  
  vfmsub132ps %xmm7, %xmm2, %xmm1     #  4     0xd   5      OPC=vfmsub132ps_xmm_xmm_xmm   
  retq                                #  5     0x12  1      OPC=retq                      
                                                                                          
.size target, .-target
