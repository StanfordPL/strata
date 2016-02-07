  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                 #  Line  RIP   Bytes  Opcode                
.target:                               #        0     0      OPC=<label>           
  callq .move_128_064_xmm3_r12_r13     #  1     0     5      OPC=callq_label       
  callq .move_128_64_xmm2_xmm12_xmm13  #  2     0x5   5      OPC=callq_label       
  vmovq %r13, %xmm1                    #  3     0xa   5      OPC=vmovq_xmm_r64     
  unpcklps %xmm1, %xmm13               #  4     0xf   4      OPC=unpcklps_xmm_xmm  
  vmovups %xmm13, %xmm1                #  5     0x13  5      OPC=vmovups_xmm_xmm   
  retq                                 #  6     0x18  1      OPC=retq              
                                                                                   
.size target, .-target
