  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                              #  Line  RIP  Bytes  Opcode                        
.target:                            #        0    0      OPC=<label>                   
  vfnmsub132pd %xmm1, %xmm3, %xmm2  #  1     0    5      OPC=vfnmsub132pd_xmm_xmm_xmm  
  vpbroadcastq %xmm2, %xmm8         #  2     0x5  5      OPC=vpbroadcastq_xmm_xmm      
  vmovhlps %xmm8, %xmm1, %xmm1      #  3     0xa  5      OPC=vmovhlps_xmm_xmm_xmm      
  retq                              #  4     0xf  1      OPC=retq                      
                                                                                       
.size target, .-target
