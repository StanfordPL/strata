  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                               #  Line  RIP  Bytes  Opcode                       
.target:                             #        0    0      OPC=<label>                  
  callq .move_128_64_xmm1_xmm8_xmm9  #  1     0    5      OPC=callq_label              
  vfmadd132sd %xmm3, %xmm8, %xmm2    #  2     0x5  5      OPC=vfmadd132sd_xmm_xmm_xmm  
  vmovlhps %xmm9, %xmm2, %xmm1       #  3     0xa  5      OPC=vmovlhps_xmm_xmm_xmm     
  retq                               #  4     0xf  1      OPC=retq                     
                                                                                       
.size target, .-target
