  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                #  Line  RIP   Bytes  Opcode                       
.target:                              #        0     0      OPC=<label>                  
  vpunpcklqdq %xmm3, %xmm2, %xmm1     #  1     0     4      OPC=vpunpcklqdq_xmm_xmm_xmm  
  vpunpckhqdq %xmm3, %xmm2, %xmm8     #  2     0x4   4      OPC=vpunpckhqdq_xmm_xmm_xmm  
  callq .move_byte_31_of_ymm1_to_r9b  #  3     0x8   5      OPC=callq_label              
  callq .move_r9b_to_byte_17_of_ymm1  #  4     0xd   5      OPC=callq_label              
  vaddpd %ymm8, %ymm1, %ymm1          #  5     0x12  5      OPC=vaddpd_ymm_ymm_ymm       
  retq                                #  6     0x17  1      OPC=retq                     
                                                                                         
.size target, .-target
