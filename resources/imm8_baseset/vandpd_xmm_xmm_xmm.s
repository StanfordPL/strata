  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                        #  Line  RIP   Bytes  Opcode                  
.target:                      #        0     0      OPC=<label>             
  vmulss %xmm3, %xmm2, %xmm1  #  1     0     4      OPC=vmulss_xmm_xmm_xmm  
  punpcklqdq %xmm3, %xmm1     #  2     0x4   4      OPC=punpcklqdq_xmm_xmm  
  pand %xmm2, %xmm3           #  3     0x8   4      OPC=pand_xmm_xmm        
  vpandn %xmm1, %xmm1, %xmm1  #  4     0xc   4      OPC=vpandn_xmm_xmm_xmm  
  movdqu %xmm3, %xmm1         #  5     0x10  4      OPC=movdqu_xmm_xmm      
  retq                        #  6     0x14  1      OPC=retq                
                                                                            
.size target, .-target
