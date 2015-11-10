  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                              #  Line  RIP   Bytes  Opcode                      
.target:                            #        0     0      OPC=<label>                 
  pmovzxdq %xmm2, %xmm2             #  1     0     5      OPC=pmovzxdq_xmm_xmm        
  callq .move_128_064_xmm2_r10_r11  #  2     0x5   5      OPC=callq_label             
  vzeroall                          #  3     0xa   3      OPC=vzeroall                
  vcvtsi2sdl %r11d, %xmm15, %xmm5   #  4     0xd   5      OPC=vcvtsi2sdl_xmm_xmm_r32  
  xchgw %r10w, %r10w                #  5     0x12  4      OPC=xchgw_r16_r16           
  vpbroadcastq %xmm5, %ymm3         #  6     0x16  5      OPC=vpbroadcastq_ymm_xmm    
  vcvtsi2sdl %r10d, %xmm3, %xmm1    #  7     0x1b  5      OPC=vcvtsi2sdl_xmm_xmm_r32  
  retq                              #  8     0x20  1      OPC=retq                    
                                                                                      
.size target, .-target
