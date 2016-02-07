  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                  #  Line  RIP  Bytes  Opcode               
.target:                #        0    0      OPC=<label>          
  movupd %xmm2, %xmm5   #  1     0    4      OPC=movupd_xmm_xmm   
  andpd %xmm3, %xmm5    #  2     0x4  4      OPC=andpd_xmm_xmm    
  vmovapd %xmm5, %xmm1  #  3     0x8  4      OPC=vmovapd_xmm_xmm  
  retq                  #  4     0xc  1      OPC=retq             
                                                                  
.size target, .-target
