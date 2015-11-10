  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                              #  Line  RIP   Bytes  Opcode              
.target:                            #        0     0      OPC=<label>         
  callq .move_128_064_xmm3_r12_r13  #  1     0     5      OPC=callq_label     
  callq .move_128_064_xmm2_r8_r9    #  2     0x5   5      OPC=callq_label     
  vzeroall                          #  3     0xa   3      OPC=vzeroall        
  incw %r13w                        #  4     0xd   4      OPC=incw_r16        
  xchgq %r13, %r9                   #  5     0x11  3      OPC=xchgq_r64_r64   
  callq .move_064_128_r12_r13_xmm1  #  6     0x14  5      OPC=callq_label     
  sqrtsd %xmm1, %xmm1               #  7     0x19  4      OPC=sqrtsd_xmm_xmm  
  retq                              #  8     0x1d  1      OPC=retq            
                                                                              
.size target, .-target
