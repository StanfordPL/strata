  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                      #  Line  RIP   Bytes  Opcode                    
.target:                                    #        0     0      OPC=<label>               
  callq .move_128_032_xmm2_eax_edx_r8d_r9d  #  1     0     5      OPC=callq_label           
  vmovd %eax, %xmm6                         #  2     0x5   4      OPC=vmovd_xmm_r32         
  vbroadcastsd %xmm6, %ymm7                 #  3     0x9   5      OPC=vbroadcastsd_ymm_xmm  
  vbroadcastss %xmm7, %ymm1                 #  4     0xe   5      OPC=vbroadcastss_ymm_xmm  
  retq                                      #  5     0x13  1      OPC=retq                  
                                                                                            
.size target, .-target
