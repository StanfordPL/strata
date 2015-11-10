  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                 #  Line  RIP   Bytes  Opcode             
.target:                               #        0     0      OPC=<label>        
  divsd %xmm2, %xmm1                   #  1     0     4      OPC=divsd_xmm_xmm  
  callq .move_128_64_xmm2_xmm12_xmm13  #  2     0x4   5      OPC=callq_label    
  callq .move_128_64_xmm1_xmm8_xmm9    #  3     0x9   5      OPC=callq_label    
  divsd %xmm13, %xmm9                  #  4     0xe   5      OPC=divsd_xmm_xmm  
  callq .move_64_128_xmm8_xmm9_xmm1    #  5     0x13  5      OPC=callq_label    
  retq                                 #  6     0x18  1      OPC=retq           
                                                                                
.size target, .-target
