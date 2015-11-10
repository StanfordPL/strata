  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                               #  Line  RIP  Bytes  Opcode                        
.target:                             #        0    0      OPC=<label>                   
  callq .move_128_64_xmm1_xmm8_xmm9  #  1     0    5      OPC=callq_label               
  movss %xmm2, %xmm1                 #  2     0x5  4      OPC=movss_xmm_xmm             
  vfnmadd132ss %xmm8, %xmm3, %xmm1   #  3     0x9  5      OPC=vfnmadd132ss_xmm_xmm_xmm  
  retq                               #  4     0xe  1      OPC=retq                      
                                                                                        
.size target, .-target
