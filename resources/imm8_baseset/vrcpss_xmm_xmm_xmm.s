  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                      #  Line  RIP   Bytes  Opcode                  
.target:                                    #        0     0      OPC=<label>             
  vrcpps %xmm3, %xmm1                       #  1     0     4      OPC=vrcpps_xmm_xmm      
  callq .move_128_032_xmm2_eax_edx_r8d_r9d  #  2     0x4   5      OPC=callq_label         
  callq .move_r8b_to_byte_14_of_ymm1        #  3     0x9   5      OPC=callq_label         
  vmovss %xmm1, %xmm2, %xmm13               #  4     0xe   4      OPC=vmovss_xmm_xmm_xmm  
  movdqa %xmm13, %xmm1                      #  5     0x12  5      OPC=movdqa_xmm_xmm      
  retq                                      #  6     0x17  1      OPC=retq                
                                                                                          
.size target, .-target
