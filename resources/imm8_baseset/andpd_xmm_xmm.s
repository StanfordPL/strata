  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                         #  Line  RIP  Bytes  Opcode                  
.target:                       #        0    0      OPC=<label>             
  vpxor %xmm1, %xmm2, %xmm3    #  1     0    4      OPC=vpxor_xmm_xmm_xmm   
  vpandn %xmm1, %xmm3, %xmm10  #  2     0x4  4      OPC=vpandn_xmm_xmm_xmm  
  movups %xmm10, %xmm1         #  3     0x8  4      OPC=movups_xmm_xmm      
  retq                         #  4     0xc  1      OPC=retq                
                                                                            
.size target, .-target
