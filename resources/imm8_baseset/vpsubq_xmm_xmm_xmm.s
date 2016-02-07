  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                            #  Line  RIP   Bytes  Opcode                 
.target:                          #        0     0      OPC=<label>            
  vcvtdq2pd %xmm3, %xmm1          #  1     0     4      OPC=vcvtdq2pd_xmm_xmm  
  callq .move_128_064_xmm3_r8_r9  #  2     0x4   5      OPC=callq_label        
  notq %r9                        #  3     0x9   3      OPC=notq_r64           
  incq %r9                        #  4     0xc   3      OPC=incq_r64           
  notq %r8                        #  5     0xf   3      OPC=notq_r64           
  incq %r8                        #  6     0x12  3      OPC=incq_r64           
  callq .move_064_128_r8_r9_xmm1  #  7     0x15  5      OPC=callq_label        
  paddq %xmm2, %xmm1              #  8     0x1a  4      OPC=paddq_xmm_xmm      
  retq                            #  9     0x1e  1      OPC=retq               
                                                                               
.size target, .-target
