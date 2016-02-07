  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                         #  Line  RIP   Bytes  Opcode                  
.target:                       #        0     0      OPC=<label>             
  movdqu %xmm2, %xmm13         #  1     0     5      OPC=movdqu_xmm_xmm      
  addpd %xmm3, %xmm13          #  2     0x5   5      OPC=addpd_xmm_xmm       
  vsubpd %xmm3, %xmm2, %xmm0   #  3     0xa   4      OPC=vsubpd_xmm_xmm_xmm  
  vmovsd %xmm0, %xmm13, %xmm1  #  4     0xe   4      OPC=vmovsd_xmm_xmm_xmm  
  retq                         #  5     0x12  1      OPC=retq                
                                                                             
.size target, .-target
