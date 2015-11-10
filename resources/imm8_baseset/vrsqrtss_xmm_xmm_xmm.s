  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                        #  Line  RIP   Bytes  Opcode                  
.target:                      #        0     0      OPC=<label>             
  vmaxss %xmm2, %xmm3, %xmm1  #  1     0     4      OPC=vmaxss_xmm_xmm_xmm  
  movdqu %xmm2, %xmm1         #  2     0x4   4      OPC=movdqu_xmm_xmm      
  vpmovzxdq %xmm3, %xmm6      #  3     0x8   5      OPC=vpmovzxdq_xmm_xmm   
  rsqrtss %xmm6, %xmm1        #  4     0xd   4      OPC=rsqrtss_xmm_xmm     
  retq                        #  5     0x11  1      OPC=retq                
                                                                            
.size target, .-target
