  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                              #  Line  RIP   Bytes  Opcode                     
.target:                            #        0     0      OPC=<label>                
  callq .move_128_064_xmm2_r10_r11  #  1     0     5      OPC=callq_label            
  vzeroall                          #  2     0x5   3      OPC=vzeroall               
  callq .move_064_128_r10_r11_xmm2  #  3     0x8   5      OPC=callq_label            
  vcvtss2sd %xmm2, %xmm14, %xmm1    #  4     0xd   4      OPC=vcvtss2sd_xmm_xmm_xmm  
  cvtps2pd %xmm2, %xmm1             #  5     0x11  3      OPC=cvtps2pd_xmm_xmm       
  retq                              #  6     0x14  1      OPC=retq                   
                                                                                     
.size target, .-target
