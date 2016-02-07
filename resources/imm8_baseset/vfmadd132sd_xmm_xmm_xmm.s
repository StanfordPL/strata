  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                            #  Line  RIP   Bytes  Opcode                       
.target:                                          #        0     0      OPC=<label>                  
  callq .move_128_032_xmm3_xmm8_xmm9_xmm10_xmm11  #  1     0     5      OPC=callq_label              
  vfmadd213pd %xmm2, %xmm1, %xmm3                 #  2     0x5   5      OPC=vfmadd213pd_xmm_xmm_xmm  
  movlhps %xmm11, %xmm3                           #  3     0xa   4      OPC=movlhps_xmm_xmm          
  vmovsd %xmm3, %xmm1, %xmm1                      #  4     0xe   4      OPC=vmovsd_xmm_xmm_xmm       
  retq                                            #  5     0x12  1      OPC=retq                     
                                                                                                     
.size target, .-target
