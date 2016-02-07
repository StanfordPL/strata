  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                  #  Line  RIP   Bytes  Opcode                 
.target:                                #        0     0      OPC=<label>            
  callq .move_128_064_xmm2_r8_r9        #  1     0     5      OPC=callq_label        
  vzeroall                              #  2     0x5   3      OPC=vzeroall           
  callq .move_r9b_to_byte_2_of_ymm1     #  3     0x8   5      OPC=callq_label        
  callq .move_byte_28_of_ymm1_to_r9b    #  4     0xd   5      OPC=callq_label        
  callq .move_064_128_r8_r9_xmm3        #  5     0x12  5      OPC=callq_label        
  vcvtdq2pd %ymm3, %ymm12               #  6     0x17  4      OPC=vcvtdq2pd_ymm_ymm  
  callq .move_128_256_xmm12_xmm13_ymm1  #  7     0x1b  5      OPC=callq_label        
  retq                                  #  8     0x20  1      OPC=retq               
                                                                                     
.size target, .-target
