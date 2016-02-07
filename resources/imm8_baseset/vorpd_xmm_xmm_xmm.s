  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                            #  Line  RIP   Bytes  Opcode                  
.target:                                          #        0     0      OPC=<label>             
  callq .move_128_064_xmm2_r8_r9                  #  1     0     5      OPC=callq_label         
  callq .move_128_064_xmm3_r10_r11                #  2     0x5   5      OPC=callq_label         
  callq .move_128_032_xmm2_xmm8_xmm9_xmm10_xmm11  #  3     0xa   5      OPC=callq_label         
  vmaxss %xmm8, %xmm3, %xmm1                      #  4     0xf   5      OPC=vmaxss_xmm_xmm_xmm  
  orq %r10, %r8                                   #  5     0x14  3      OPC=orq_r64_r64         
  orq %r11, %r9                                   #  6     0x17  3      OPC=orq_r64_r64         
  callq .move_064_128_r8_r9_xmm1                  #  7     0x1a  5      OPC=callq_label         
  retq                                            #  8     0x1f  1      OPC=retq                
                                                                                                
.size target, .-target
