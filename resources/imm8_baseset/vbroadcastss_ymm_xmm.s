  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                              #  Line  RIP   Bytes  Opcode                    
.target:                            #        0     0      OPC=<label>               
  callq .move_128_064_xmm2_r10_r11  #  1     0     5      OPC=callq_label           
  vmovq %r10, %xmm3                 #  2     0x5   5      OPC=vmovq_xmm_r64         
  vpbroadcastd %xmm3, %xmm9         #  3     0xa   5      OPC=vpbroadcastd_xmm_xmm  
  vbroadcastsd %xmm9, %ymm1         #  4     0xf   5      OPC=vbroadcastsd_ymm_xmm  
  retq                              #  5     0x14  1      OPC=retq                  
                                                                                    
.size target, .-target
