  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                        #  Line  RIP  Bytes  Opcode                 
.target:                      #        0    0      OPC=<label>            
  orps %xmm1, %xmm2           #  1     0    3      OPC=orps_xmm_xmm       
  vpxor %xmm1, %xmm2, %xmm10  #  2     0x3  4      OPC=vpxor_xmm_xmm_xmm  
  movapd %xmm10, %xmm1        #  3     0x7  5      OPC=movapd_xmm_xmm     
  retq                        #  4     0xc  1      OPC=retq               
                                                                          
.size target, .-target
