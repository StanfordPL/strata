  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                          #  Line  RIP   Bytes  Opcode                 
.target:                                        #        0     0      OPC=<label>            
  callq .move_128_032_xmm2_xmm4_xmm5_xmm6_xmm7  #  1     0     5      OPC=callq_label        
  vpmovzxwq %xmm5, %xmm5                        #  2     0x5   5      OPC=vpmovzxwq_xmm_xmm  
  vpmovzxwq %xmm2, %xmm9                        #  3     0xa   5      OPC=vpmovzxwq_xmm_xmm  
  hsubps %xmm5, %xmm9                           #  4     0xf   5      OPC=hsubps_xmm_xmm     
  movups %xmm9, %xmm1                           #  5     0x14  4      OPC=movups_xmm_xmm     
  retq                                          #  6     0x18  1      OPC=retq               
                                                                                             
.size target, .-target
