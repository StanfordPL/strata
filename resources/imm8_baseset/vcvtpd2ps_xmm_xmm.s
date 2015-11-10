  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                 #  Line  RIP   Bytes  Opcode                     
.target:                               #        0     0      OPC=<label>                
  callq .move_128_64_xmm2_xmm10_xmm11  #  1     0     5      OPC=callq_label            
  vcvtsd2ss %xmm2, %xmm11, %xmm8       #  2     0x5   4      OPC=vcvtsd2ss_xmm_xmm_xmm  
  vcvtsd2ss %xmm11, %xmm8, %xmm7       #  3     0x9   5      OPC=vcvtsd2ss_xmm_xmm_xmm  
  vunpcklps %ymm7, %ymm8, %ymm2        #  4     0xe   4      OPC=vunpcklps_ymm_ymm_ymm  
  vmovq %xmm2, %xmm1                   #  5     0x12  4      OPC=vmovq_xmm_xmm          
  retq                                 #  6     0x16  1      OPC=retq                   
                                                                                        
.size target, .-target
