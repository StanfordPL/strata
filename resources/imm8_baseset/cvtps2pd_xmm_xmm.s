  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                                            #  Line  RIP   Bytes  Opcode                     
.target:                                          #        0     0      OPC=<label>                
  callq .move_128_032_xmm2_xmm8_xmm9_xmm10_xmm11  #  1     0     5      OPC=callq_label            
  callq .move_128_032_xmm2_xmm4_xmm5_xmm6_xmm7    #  2     0x5   5      OPC=callq_label            
  vcvtss2sd %xmm9, %xmm4, %xmm9                   #  3     0xa   5      OPC=vcvtss2sd_xmm_xmm_xmm  
  cvtss2sd %xmm4, %xmm8                           #  4     0xf   5      OPC=cvtss2sd_xmm_xmm       
  callq .move_64_128_xmm8_xmm9_xmm1               #  5     0x14  5      OPC=callq_label            
  retq                                            #  6     0x19  1      OPC=retq                   
                                                                                                   
.size target, .-target
