  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                              #  Line  RIP   Bytes  Opcode                  
.target:                            #        0     0      OPC=<label>             
  vmovss %xmm2, %xmm2, %xmm1        #  1     0     4      OPC=vmovss_xmm_xmm_xmm  
  callq .move_128_064_xmm1_r8_r9    #  2     0x4   5      OPC=callq_label         
  callq .move_128_064_xmm3_r10_r11  #  3     0x9   5      OPC=callq_label         
  vmovdqu %ymm1, %ymm1              #  4     0xe   4      OPC=vmovdqu_ymm_ymm     
  xorq %r9, %r11                    #  5     0x12  3      OPC=xorq_r64_r64        
  xorq %r8, %r10                    #  6     0x15  3      OPC=xorq_r64_r64        
  callq .move_064_128_r10_r11_xmm1  #  7     0x18  5      OPC=callq_label         
  retq                              #  8     0x1d  1      OPC=retq                
                                                                                  
.size target, .-target
