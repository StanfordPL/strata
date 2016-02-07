  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                        #  Line  RIP  Bytes  Opcode                  
.target:                      #        0    0      OPC=<label>             
  vmovddup %xmm2, %xmm3       #  1     0    4      OPC=vmovddup_xmm_xmm    
  vsubps %xmm3, %xmm1, %xmm2  #  2     0x4  4      OPC=vsubps_xmm_xmm_xmm  
  movss %xmm2, %xmm1          #  3     0x8  4      OPC=movss_xmm_xmm       
  retq                        #  4     0xc  1      OPC=retq                
                                                                           
.size target, .-target
