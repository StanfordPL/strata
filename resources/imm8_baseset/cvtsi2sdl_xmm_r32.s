  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                 #  Line  RIP  Bytes  Opcode                      
.target:                               #        0    0      OPC=<label>                 
  vcvtsi2sdl %ebx, %xmm1, %xmm3        #  1     0    4      OPC=vcvtsi2sdl_xmm_xmm_r32  
  callq .move_128_64_xmm3_xmm10_xmm11  #  2     0x4  5      OPC=callq_label             
  callq .move_64_128_xmm10_xmm11_xmm1  #  3     0x9  5      OPC=callq_label             
  retq                                 #  4     0xe  1      OPC=retq                    
                                                                                        
.size target, .-target
