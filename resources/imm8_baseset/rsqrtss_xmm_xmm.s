  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                        #  Line  RIP  Bytes  Opcode                    
.target:                      #        0    0      OPC=<label>               
  vbroadcastss %xmm2, %xmm15  #  1     0    5      OPC=vbroadcastss_xmm_xmm  
  vrsqrtps %ymm15, %ymm10     #  2     0x5  5      OPC=vrsqrtps_ymm_ymm      
  movss %xmm10, %xmm1         #  3     0xa  5      OPC=movss_xmm_xmm         
  retq                        #  4     0xf  1      OPC=retq                  
                                                                             
.size target, .-target
