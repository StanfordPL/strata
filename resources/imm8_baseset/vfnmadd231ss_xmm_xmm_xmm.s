  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                          #  Line  RIP  Bytes  Opcode                        
.target:                                        #        0    0      OPC=<label>                   
  vfnmadd213ps %xmm1, %xmm2, %xmm3              #  1     0    5      OPC=vfnmadd213ps_xmm_xmm_xmm  
  callq .move_128_032_xmm3_xmm4_xmm5_xmm6_xmm7  #  2     0x5  5      OPC=callq_label               
  vmovss %xmm4, %xmm1, %xmm1                    #  3     0xa  4      OPC=vmovss_xmm_xmm_xmm        
  retq                                          #  4     0xe  1      OPC=retq                      
                                                                                                   
.size target, .-target
