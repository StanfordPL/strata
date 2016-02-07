  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                 #  Line  RIP   Bytes  Opcode                       
.target:                               #        0     0      OPC=<label>                  
  vmovupd %xmm1, %xmm7                 #  1     0     4      OPC=vmovupd_xmm_xmm          
  callq .move_128_64_xmm3_xmm12_xmm13  #  2     0x4   5      OPC=callq_label              
  vfmsub231pd %xmm3, %xmm2, %xmm1      #  3     0x9   5      OPC=vfmsub231pd_xmm_xmm_xmm  
  vmovhlps %xmm7, %xmm12, %xmm11       #  4     0xe   4      OPC=vmovhlps_xmm_xmm_xmm     
  vpunpcklqdq %xmm11, %xmm1, %xmm1     #  5     0x12  5      OPC=vpunpcklqdq_xmm_xmm_xmm  
  retq                                 #  6     0x17  1      OPC=retq                     
                                                                                          
.size target, .-target
