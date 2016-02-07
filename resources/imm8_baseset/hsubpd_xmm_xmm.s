  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                 #  Line  RIP   Bytes  Opcode                    
.target:                               #        0     0      OPC=<label>               
  callq .move_128_64_xmm2_xmm12_xmm13  #  1     0     5      OPC=callq_label           
  vmovhlps %xmm1, %xmm2, %xmm14        #  2     0x5   4      OPC=vmovhlps_xmm_xmm_xmm  
  punpcklqdq %xmm12, %xmm1             #  3     0x9   5      OPC=punpcklqdq_xmm_xmm    
  subpd %xmm14, %xmm1                  #  4     0xe   5      OPC=subpd_xmm_xmm         
  retq                                 #  5     0x13  1      OPC=retq                  
                                                                                       
.size target, .-target
