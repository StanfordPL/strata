  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                 #  Line  RIP   Bytes  Opcode                       
.target:                               #        0     0      OPC=<label>                  
  vfmsub231sd %xmm1, %xmm2, %xmm3      #  1     0     5      OPC=vfmsub231sd_xmm_xmm_xmm  
  callq .move_128_64_xmm3_xmm10_xmm11  #  2     0x5   5      OPC=callq_label              
  vfmadd231pd %xmm1, %xmm2, %xmm3      #  3     0xa   5      OPC=vfmadd231pd_xmm_xmm_xmm  
  vmovsd %xmm10, %xmm3, %xmm1          #  4     0xf   5      OPC=vmovsd_xmm_xmm_xmm       
  retq                                 #  5     0x14  1      OPC=retq                     
                                                                                          
.size target, .-target
