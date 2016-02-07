  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                 #  Line  RIP   Bytes  Opcode                  
.target:                               #        0     0      OPC=<label>             
  movdqu %xmm3, %xmm4                  #  1     0     4      OPC=movdqu_xmm_xmm      
  hsubpd %xmm4, %xmm2                  #  2     0x4   4      OPC=hsubpd_xmm_xmm      
  callq .move_128_64_xmm2_xmm12_xmm13  #  3     0x8   5      OPC=callq_label         
  vsubps %xmm12, %xmm3, %xmm1          #  4     0xd   5      OPC=vsubps_xmm_xmm_xmm  
  callq .move_64_128_xmm12_xmm13_xmm1  #  5     0x12  5      OPC=callq_label         
  retq                                 #  6     0x17  1      OPC=retq                
                                                                                     
.size target, .-target
