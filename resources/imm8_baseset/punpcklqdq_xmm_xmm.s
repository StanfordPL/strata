  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                      #  Line  RIP  Bytes  Opcode               
.target:                                    #        0    0      OPC=<label>          
  movlhps %xmm2, %xmm1                      #  1     0    3      OPC=movlhps_xmm_xmm  
  callq .move_128_032_xmm1_eax_edx_r8d_r9d  #  2     0x3  5      OPC=callq_label      
  callq .move_r8b_to_byte_8_of_ymm1         #  3     0x8  5      OPC=callq_label      
  retq                                      #  4     0xd  1      OPC=retq             
                                                                                      
.size target, .-target
