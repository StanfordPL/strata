  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                               #  Line  RIP   Bytes  Opcode                    
.target:                             #        0     0      OPC=<label>               
  vpbroadcastq %xmm2, %xmm1          #  1     0     5      OPC=vpbroadcastq_xmm_xmm  
  vmovq %xmm1, %rcx                  #  2     0x5   5      OPC=vmovq_r64_xmm         
  vzeroall                           #  3     0xa   3      OPC=vzeroall              
  callq .move_128_064_xmm2_r10_r11   #  4     0xd   5      OPC=callq_label           
  callq .move_032_016_ecx_r10w_r11w  #  5     0x12  5      OPC=callq_label           
  callq .move_064_128_r10_r11_xmm1   #  6     0x17  5      OPC=callq_label           
  retq                               #  7     0x1c  1      OPC=retq                  
                                                                                     
.size target, .-target
