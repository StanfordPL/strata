  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                #  Line  RIP   Bytes  Opcode                    
.target:                              #        0     0      OPC=<label>               
  callq .move_128_064_xmm2_r8_r9      #  1     0     5      OPC=callq_label           
  vzeroall                            #  2     0x5   3      OPC=vzeroall              
  divss %xmm1, %xmm1                  #  3     0x8   4      OPC=divss_xmm_xmm         
  callq .move_byte_20_of_ymm1_to_r9b  #  4     0xc   5      OPC=callq_label           
  callq .move_064_128_r8_r9_xmm1      #  5     0x11  5      OPC=callq_label           
  callq .move_r8b_to_byte_12_of_ymm1  #  6     0x16  5      OPC=callq_label           
  vbroadcastss %xmm1, %xmm1           #  7     0x1b  5      OPC=vbroadcastss_xmm_xmm  
  retq                                #  8     0x20  1      OPC=retq                  
                                                                                      
.size target, .-target
