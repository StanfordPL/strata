  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                            #  Line  RIP   Bytes  Opcode                        
.target:                                          #        0     0      OPC=<label>                   
  callq .move_128_032_xmm2_xmm8_xmm9_xmm10_xmm11  #  1     0     5      OPC=callq_label               
  vpunpckhdq %xmm10, %xmm11, %xmm11               #  2     0x5   5      OPC=vpunpckhdq_xmm_xmm_xmm    
  vfnmsub231sd %xmm11, %xmm11, %xmm3              #  3     0xa   5      OPC=vfnmsub231sd_xmm_xmm_xmm  
  vfmsub213pd %xmm3, %xmm2, %xmm1                 #  4     0xf   5      OPC=vfmsub213pd_xmm_xmm_xmm   
  retq                                            #  5     0x14  1      OPC=retq                      
                                                                                                      
.size target, .-target
