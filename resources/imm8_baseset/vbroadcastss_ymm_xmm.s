  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                  #  Line  RIP   Bytes  Opcode                    
.target:                                #        0     0      OPC=<label>               
  callq .move_128_064_xmm2_r12_r13      #  1     0     5      OPC=callq_label           
  vzeroall                              #  2     0x5   3      OPC=vzeroall              
  callq .move_064_128_r12_r13_xmm3      #  3     0x8   5      OPC=callq_label           
  vbroadcastss %xmm3, %xmm13            #  4     0xd   5      OPC=vbroadcastss_xmm_xmm  
  vbroadcastsd %xmm13, %ymm13           #  5     0x12  5      OPC=vbroadcastsd_ymm_xmm  
  callq .move_128_256_xmm12_xmm13_ymm1  #  6     0x17  5      OPC=callq_label           
  movaps %xmm13, %xmm1                  #  7     0x1c  4      OPC=movaps_xmm_xmm        
  retq                                  #  8     0x20  1      OPC=retq                  
                                                                                        
.size target, .-target
