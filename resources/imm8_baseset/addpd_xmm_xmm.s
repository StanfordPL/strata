  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                 #  Line  RIP   Bytes  Opcode                    
.target:                               #        0     0      OPC=<label>               
  vmovhlps %xmm1, %xmm2, %xmm3         #  1     0     4      OPC=vmovhlps_xmm_xmm_xmm  
  callq .move_128_64_xmm2_xmm12_xmm13  #  2     0x4   5      OPC=callq_label           
  movlhps %xmm12, %xmm1                #  3     0x9   4      OPC=movlhps_xmm_xmm       
  haddpd %xmm3, %xmm1                  #  4     0xd   4      OPC=haddpd_xmm_xmm        
  retq                                 #  5     0x11  1      OPC=retq                  
                                                                                       
.size target, .-target