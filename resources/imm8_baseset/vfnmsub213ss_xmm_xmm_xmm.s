  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                               #  Line  RIP   Bytes  Opcode                        
.target:                             #        0     0      OPC=<label>                   
  vmovsldup %xmm1, %xmm12            #  1     0     4      OPC=vmovsldup_xmm_xmm         
  movss %xmm2, %xmm1                 #  2     0x4   4      OPC=movss_xmm_xmm             
  callq .move_128_64_xmm1_xmm8_xmm9  #  3     0x8   5      OPC=callq_label               
  callq .move_64_128_xmm8_xmm9_xmm1  #  4     0xd   5      OPC=callq_label               
  vfnmsub132ss %xmm12, %xmm3, %xmm1  #  5     0x12  5      OPC=vfnmsub132ss_xmm_xmm_xmm  
  retq                               #  6     0x17  1      OPC=retq                      
                                                                                         
.size target, .-target
