  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                 #  Line  RIP   Bytes  Opcode                        
.target:                               #        0     0      OPC=<label>                   
  callq .move_128_64_xmm1_xmm10_xmm11  #  1     0     5      OPC=callq_label               
  callq .move_128_64_xmm2_xmm12_xmm13  #  2     0x5   5      OPC=callq_label               
  movss %xmm12, %xmm1                  #  3     0xa   5      OPC=movss_xmm_xmm             
  vbroadcastsd %xmm10, %ymm10          #  4     0xf   5      OPC=vbroadcastsd_ymm_xmm      
  vfnmsub132ss %xmm3, %xmm10, %xmm1    #  5     0x14  5      OPC=vfnmsub132ss_xmm_xmm_xmm  
  retq                                 #  6     0x19  1      OPC=retq                      
                                                                                           
.size target, .-target
