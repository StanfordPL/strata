  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                            #  Line  RIP  Bytes  Opcode                
.target:                          #        0    0      OPC=<label>           
  callq .move_128_064_xmm2_r8_r9  #  1     0    5      OPC=callq_label       
  callq .move_064_128_r8_r9_xmm1  #  2     0x5  5      OPC=callq_label       
  vmovddup %xmm1, %xmm1           #  3     0xa  4      OPC=vmovddup_xmm_xmm  
  retq                            #  4     0xe  1      OPC=retq              
                                                                             
.size target, .-target
