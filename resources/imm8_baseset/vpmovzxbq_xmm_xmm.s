  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                          #  Line  RIP   Bytes  Opcode           
.target:                                        #        0     0      OPC=<label>      
  callq .move_128_064_xmm2_r8_r9                #  1     0     5      OPC=callq_label  
  callq .move_128_032_xmm2_r10d_r11d_r12d_r13d  #  2     0x5   5      OPC=callq_label  
  vzeroall                                      #  3     0xa   3      OPC=vzeroall     
  callq .move_r8b_to_byte_0_of_ymm1             #  4     0xd   5      OPC=callq_label  
  callq .move_016_032_r10w_r11w_ebx             #  5     0x12  5      OPC=callq_label  
  callq .move_016_008_bx_r8b_r9b                #  6     0x17  5      OPC=callq_label  
  callq .move_r9b_to_byte_8_of_ymm1             #  7     0x1c  5      OPC=callq_label  
  retq                                          #  8     0x21  1      OPC=retq         
                                                                                       
.size target, .-target
