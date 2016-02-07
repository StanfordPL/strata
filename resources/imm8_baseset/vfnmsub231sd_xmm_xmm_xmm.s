  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                                  #  Line  RIP   Bytes  Opcode                        
.target:                                #        0     0      OPC=<label>                   
  vmovq %xmm3, %xmm6                    #  1     0     4      OPC=vmovq_xmm_xmm             
  callq .move_128_64_xmm2_xmm10_xmm11   #  2     0x4   5      OPC=callq_label               
  callq .move_128_256_xmm10_xmm11_ymm3  #  3     0x9   5      OPC=callq_label               
  vmovaps %xmm1, %xmm1                  #  4     0xe   4      OPC=vmovaps_xmm_xmm           
  vfnmsub213pd %ymm1, %ymm3, %ymm6      #  5     0x12  5      OPC=vfnmsub213pd_ymm_ymm_ymm  
  movsd %xmm6, %xmm1                    #  6     0x17  4      OPC=movsd_xmm_xmm             
  retq                                  #  7     0x1b  1      OPC=retq                      
                                                                                            
.size target, .-target
