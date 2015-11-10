  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                #  Line  RIP   Bytes  Opcode                  
.target:                              #        0     0      OPC=<label>             
  callq .move_128_064_xmm3_r8_r9      #  1     0     5      OPC=callq_label         
  vorps %xmm3, %xmm2, %xmm1           #  2     0x5   4      OPC=vorps_xmm_xmm_xmm   
  callq .move_r9b_to_byte_28_of_ymm1  #  3     0x9   5      OPC=callq_label         
  vxorps %xmm1, %xmm2, %xmm0          #  4     0xe   4      OPC=vxorps_xmm_xmm_xmm  
  vmovapd %xmm0, %xmm1                #  5     0x12  4      OPC=vmovapd_xmm_xmm     
  retq                                #  6     0x16  1      OPC=retq                
                                                                                    
.size target, .-target
