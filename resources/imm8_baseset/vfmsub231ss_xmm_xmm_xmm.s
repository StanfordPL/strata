  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                 #  Line  RIP   Bytes  Opcode                        
.target:                               #        0     0      OPC=<label>                   
  callq .move_128_64_xmm1_xmm10_xmm11  #  1     0     5      OPC=callq_label               
  vandnps %xmm10, %xmm10, %xmm11       #  2     0x5   5      OPC=vandnps_xmm_xmm_xmm       
  vfnmsub231ss %xmm11, %xmm11, %xmm2   #  3     0xa   5      OPC=vfnmsub231ss_xmm_xmm_xmm  
  pmovzxdq %xmm3, %xmm6                #  4     0xf   5      OPC=pmovzxdq_xmm_xmm          
  vfnmsub231ss %xmm6, %xmm2, %xmm1     #  5     0x14  5      OPC=vfnmsub231ss_xmm_xmm_xmm  
  retq                                 #  6     0x19  1      OPC=retq                      
                                                                                           
.size target, .-target
