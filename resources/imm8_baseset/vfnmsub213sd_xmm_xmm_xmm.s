  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                               #  Line  RIP   Bytes  Opcode                        
.target:                             #        0     0      OPC=<label>                   
  callq .move_128_064_xmm1_r8_r9     #  1     0     5      OPC=callq_label               
  callq .move_128_064_xmm2_r10_r11   #  2     0x5   5      OPC=callq_label               
  vpandn %xmm3, %xmm1, %xmm11        #  3     0xa   4      OPC=vpandn_xmm_xmm_xmm        
  movq %r9, %r11                     #  4     0xe   3      OPC=movq_r64_r64              
  callq .move_064_128_r10_r11_xmm1   #  5     0x11  5      OPC=callq_label               
  vmovsd %xmm3, %xmm11, %xmm14       #  6     0x16  4      OPC=vmovsd_xmm_xmm_xmm        
  callq .move_064_128_r8_r9_xmm3     #  7     0x1a  5      OPC=callq_label               
  vfnmsub132sd %xmm3, %xmm14, %xmm1  #  8     0x1f  5      OPC=vfnmsub132sd_xmm_xmm_xmm  
  retq                               #  9     0x24  1      OPC=retq                      
                                                                                         
.size target, .-target
