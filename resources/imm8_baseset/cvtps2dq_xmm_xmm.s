  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                      #  Line  RIP  Bytes  Opcode                 
.target:                    #        0    0      OPC=<label>            
  movdqu %xmm2, %xmm13      #  1     0    5      OPC=movdqu_xmm_xmm     
  vcvtps2dq %xmm13, %xmm10  #  2     0x5  5      OPC=vcvtps2dq_xmm_xmm  
  movdqa %xmm10, %xmm1      #  3     0xa  5      OPC=movdqa_xmm_xmm     
  retq                      #  4     0xf  1      OPC=retq               
                                                                        
.size target, .-target
