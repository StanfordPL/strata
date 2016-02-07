  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                               #  Line  RIP   Bytes  Opcode                    
.target:                             #        0     0      OPC=<label>               
  vmovups %xmm1, %xmm3               #  1     0     4      OPC=vmovups_xmm_xmm       
  vbroadcastss %xmm3, %xmm11         #  2     0x4   5      OPC=vbroadcastss_xmm_xmm  
  vcvttps2dq %ymm11, %ymm1           #  3     0x9   5      OPC=vcvttps2dq_ymm_ymm    
  callq .move_128_64_xmm1_xmm8_xmm9  #  4     0xe   5      OPC=callq_label           
  vmovups %xmm8, %xmm6               #  5     0x13  5      OPC=vmovups_xmm_xmm       
  vmovd %xmm6, %ebx                  #  6     0x18  4      OPC=vmovd_r32_xmm         
  retq                               #  7     0x1c  1      OPC=retq                  
                                                                                     
.size target, .-target
