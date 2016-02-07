  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                            #  Line  RIP   Bytes  Opcode                        
.target:                                          #        0     0      OPC=<label>                   
  callq .move_128_032_xmm1_xmm8_xmm9_xmm10_xmm11  #  1     0     5      OPC=callq_label               
  vmovapd %xmm2, %xmm8                            #  2     0x5   4      OPC=vmovapd_xmm_xmm           
  vfnmsub132ss %xmm1, %xmm3, %xmm8                #  3     0x9   5      OPC=vfnmsub132ss_xmm_xmm_xmm  
  vsqrtss %xmm1, %xmm10, %xmm1                    #  4     0xe   4      OPC=vsqrtss_xmm_xmm_xmm       
  callq .move_032_128_xmm8_xmm9_xmm10_xmm11_xmm1  #  5     0x12  5      OPC=callq_label               
  retq                                            #  6     0x17  1      OPC=retq                      
                                                                                                      
.size target, .-target
