  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                              #  Line  RIP   Bytes  Opcode                        
.target:                            #        0     0      OPC=<label>                   
  vfnmsub213pd %xmm2, %xmm1, %xmm3  #  1     0     5      OPC=vfnmsub213pd_xmm_xmm_xmm  
  vunpcklpd %xmm3, %xmm2, %xmm3     #  2     0x5   4      OPC=vunpcklpd_xmm_xmm_xmm     
  punpckhqdq %xmm1, %xmm3           #  3     0x9   4      OPC=punpckhqdq_xmm_xmm        
  callq .move_128_064_xmm3_r8_r9    #  4     0xd   5      OPC=callq_label               
  vzeroall                          #  5     0x12  3      OPC=vzeroall                  
  callq .move_064_128_r8_r9_xmm1    #  6     0x15  5      OPC=callq_label               
  retq                              #  7     0x1a  1      OPC=retq                      
                                                                                        
.size target, .-target
