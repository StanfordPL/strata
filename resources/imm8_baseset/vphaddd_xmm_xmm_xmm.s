  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                            #  Line  RIP   Bytes  Opcode              
.target:                          #        0     0      OPC=<label>         
  phaddd %xmm2, %xmm3             #  1     0     5      OPC=phaddd_xmm_xmm  
  callq .move_128_064_xmm3_r8_r9  #  2     0x5   5      OPC=callq_label     
  vzeroall                        #  3     0xa   3      OPC=vzeroall        
  xchgq %r8, %r9                  #  4     0xd   3      OPC=xchgq_r64_r64   
  callq .move_064_128_r8_r9_xmm1  #  5     0x10  5      OPC=callq_label     
  retq                            #  6     0x15  1      OPC=retq            
                                                                            
.size target, .-target
