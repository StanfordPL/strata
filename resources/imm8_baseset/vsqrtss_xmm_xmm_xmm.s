  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                      #  Line  RIP   Bytes  Opcode               
.target:                                    #        0     0      OPC=<label>          
  callq .move_128_032_xmm3_eax_edx_r8d_r9d  #  1     0     5      OPC=callq_label      
  vmovdqa %xmm2, %xmm1                      #  2     0x5   4      OPC=vmovdqa_xmm_xmm  
  shll $0x1, %r9d                           #  3     0x9   3      OPC=shll_r32_one     
  callq .move_r9b_to_byte_0_of_ymm1         #  4     0xc   5      OPC=callq_label      
  sqrtss %xmm3, %xmm1                       #  5     0x11  4      OPC=sqrtss_xmm_xmm   
  retq                                      #  6     0x15  1      OPC=retq             
                                                                                       
.size target, .-target
