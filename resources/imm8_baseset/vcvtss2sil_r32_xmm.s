  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                #  Line  RIP   Bytes  Opcode                 
.target:                              #        0     0      OPC=<label>            
  vmovddup %xmm1, %xmm1               #  1     0     4      OPC=vmovddup_xmm_xmm   
  xorl %r9d, %r9d                     #  2     0x4   3      OPC=xorl_r32_r32       
  callq .move_r9b_to_byte_16_of_ymm1  #  3     0x7   5      OPC=callq_label        
  vcvtps2dq %ymm1, %ymm10             #  4     0xc   4      OPC=vcvtps2dq_ymm_ymm  
  movd %xmm10, %ebx                   #  5     0x10  5      OPC=movd_r32_xmm       
  retq                                #  6     0x15  1      OPC=retq               
                                                                                   
.size target, .-target
