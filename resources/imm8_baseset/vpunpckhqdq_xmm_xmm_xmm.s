  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                              #  Line  RIP   Bytes  Opcode                
.target:                            #        0     0      OPC=<label>           
  callq .move_128_064_xmm3_r8_r9    #  1     0     5      OPC=callq_label       
  callq .move_128_064_xmm2_r12_r13  #  2     0x5   5      OPC=callq_label       
  notw %r8w                         #  3     0xa   4      OPC=notw_r16          
  vzeroall                          #  4     0xe   3      OPC=vzeroall          
  callq .move_064_128_r12_r13_xmm1  #  5     0x11  5      OPC=callq_label       
  callq .move_064_128_r8_r9_xmm3    #  6     0x16  5      OPC=callq_label       
  unpckhpd %xmm3, %xmm1             #  7     0x1b  4      OPC=unpckhpd_xmm_xmm  
  retq                              #  8     0x1f  1      OPC=retq              
                                                                                
.size target, .-target
