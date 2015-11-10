  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                #  Line  RIP   Bytes  Opcode             
.target:                              #        0     0      OPC=<label>        
  subsd %xmm2, %xmm2                  #  1     0     4      OPC=subsd_xmm_xmm  
  callq .move_128_064_xmm2_r8_r9      #  2     0x4   5      OPC=callq_label    
  callq .move_128_064_xmm3_r12_r13    #  3     0x9   5      OPC=callq_label    
  vzeroall                            #  4     0xe   3      OPC=vzeroall       
  xchgq %r9, %r13                     #  5     0x11  3      OPC=xchgq_r64_r64  
  callq .move_064_128_r12_r13_xmm1    #  6     0x14  5      OPC=callq_label    
  callq .move_byte_16_of_ymm1_to_r8b  #  7     0x19  5      OPC=callq_label    
  callq .move_r8b_to_byte_27_of_ymm1  #  8     0x1e  5      OPC=callq_label    
  retq                                #  9     0x23  1      OPC=retq           
                                                                               
.size target, .-target
