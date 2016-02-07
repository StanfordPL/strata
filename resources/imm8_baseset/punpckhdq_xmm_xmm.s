  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                        #  Line  RIP   Bytes  Opcode                  
.target:                      #        0     0      OPC=<label>             
  vmovaps %xmm1, %xmm10       #  1     0     4      OPC=vmovaps_xmm_xmm     
  vmulss %xmm1, %xmm2, %xmm0  #  2     0x4   4      OPC=vmulss_xmm_xmm_xmm  
  movhlps %xmm10, %xmm1       #  3     0x8   4      OPC=movhlps_xmm_xmm     
  punpckhqdq %xmm0, %xmm2     #  4     0xc   4      OPC=punpckhqdq_xmm_xmm  
  unpcklps %xmm2, %xmm1       #  5     0x10  3      OPC=unpcklps_xmm_xmm    
  retq                        #  6     0x13  1      OPC=retq                
                                                                            
.size target, .-target
