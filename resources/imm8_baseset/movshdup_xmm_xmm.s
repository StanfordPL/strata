  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                            #  Line  RIP   Bytes  Opcode                
.target:                                          #        0     0      OPC=<label>           
  callq .move_128_032_xmm2_xmm8_xmm9_xmm10_xmm11  #  1     0     5      OPC=callq_label       
  movupd %xmm9, %xmm10                            #  2     0x5   5      OPC=movupd_xmm_xmm    
  callq .move_032_128_xmm8_xmm9_xmm10_xmm11_xmm1  #  3     0xa   5      OPC=callq_label       
  unpckhps %xmm1, %xmm1                           #  4     0xf   3      OPC=unpckhps_xmm_xmm  
  retq                                            #  5     0x12  1      OPC=retq              
                                                                                              
.size target, .-target
