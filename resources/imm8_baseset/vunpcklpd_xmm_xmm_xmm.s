  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                 #  Line  RIP  Bytes  Opcode               
.target:                               #        0    0      OPC=<label>          
  callq .move_128_64_xmm2_xmm10_xmm11  #  1     0    5      OPC=callq_label      
  vmovapd %xmm10, %xmm1                #  2     0x5  5      OPC=vmovapd_xmm_xmm  
  movlhps %xmm3, %xmm1                 #  3     0xa  3      OPC=movlhps_xmm_xmm  
  retq                                 #  4     0xd  1      OPC=retq             
                                                                                 
.size target, .-target
