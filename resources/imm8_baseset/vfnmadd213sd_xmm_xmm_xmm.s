  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                              #  Line  RIP   Bytes  Opcode                        
.target:                            #        0     0      OPC=<label>                   
  callq .move_128_064_xmm1_r10_r11  #  1     0     5      OPC=callq_label               
  vfnmadd231pd %xmm1, %xmm2, %xmm3  #  2     0x5   5      OPC=vfnmadd231pd_xmm_xmm_xmm  
  movq %xmm3, %r10                  #  3     0xa   5      OPC=movq_r64_xmm              
  vzeroall                          #  4     0xf   3      OPC=vzeroall                  
  callq .move_064_128_r10_r11_xmm1  #  5     0x12  5      OPC=callq_label               
  retq                              #  6     0x17  1      OPC=retq                      
                                                                                        
.size target, .-target
