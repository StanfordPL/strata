  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                      #  Line  RIP   Bytes  Opcode                       
.target:                                    #        0     0      OPC=<label>                  
  callq .move_128_032_xmm1_eax_edx_r8d_r9d  #  1     0     5      OPC=callq_label              
  vpunpckhqdq %xmm1, %xmm2, %xmm3           #  2     0x5   4      OPC=vpunpckhqdq_xmm_xmm_xmm  
  unpcklpd %xmm2, %xmm1                     #  3     0x9   4      OPC=unpcklpd_xmm_xmm         
  cvtsi2ssl %eax, %xmm1                     #  4     0xd   4      OPC=cvtsi2ssl_xmm_r32        
  punpckhqdq %xmm3, %xmm1                   #  5     0x11  4      OPC=punpckhqdq_xmm_xmm       
  retq                                      #  6     0x15  1      OPC=retq                     
                                                                                               
.size target, .-target
