  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                        #  Line  RIP   Bytes  Opcode                  
.target:                      #        0     0      OPC=<label>             
  movups %xmm2, %xmm6         #  1     0     3      OPC=movups_xmm_xmm      
  vsubpd %xmm6, %xmm1, %xmm5  #  2     0x3   4      OPC=vsubpd_xmm_xmm_xmm  
  vmovddup %xmm5, %xmm7       #  3     0x7   4      OPC=vmovddup_xmm_xmm    
  divss %xmm7, %xmm1          #  4     0xb   4      OPC=divss_xmm_xmm       
  movsd %xmm5, %xmm1          #  5     0xf   4      OPC=movsd_xmm_xmm       
  retq                        #  6     0x13  1      OPC=retq                
                                                                            
.size target, .-target
