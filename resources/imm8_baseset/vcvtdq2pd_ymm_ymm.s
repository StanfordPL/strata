  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                            #  Line  RIP   Bytes  Opcode                 
.target:                                          #        0     0      OPC=<label>            
  callq .move_128_032_xmm2_xmm8_xmm9_xmm10_xmm11  #  1     0     5      OPC=callq_label        
  vcvtdq2pd %xmm11, %xmm10                        #  2     0x5   5      OPC=vcvtdq2pd_xmm_xmm  
  unpcklpd %xmm10, %xmm11                         #  3     0xa   5      OPC=unpcklpd_xmm_xmm   
  callq .move_128_064_xmm2_r12_r13                #  4     0xf   5      OPC=callq_label        
  cvtsi2sdl %r13d, %xmm11                         #  5     0x14  5      OPC=cvtsi2sdl_xmm_r32  
  vcvtdq2pd %xmm2, %xmm10                         #  6     0x19  4      OPC=vcvtdq2pd_xmm_xmm  
  callq .move_128_256_xmm10_xmm11_ymm1            #  7     0x1d  5      OPC=callq_label        
  retq                                            #  8     0x22  1      OPC=retq               
                                                                                               
.size target, .-target
