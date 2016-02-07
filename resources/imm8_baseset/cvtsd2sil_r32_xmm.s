  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                     #  Line  RIP  Bytes  Opcode                 
.target:                   #        0    0      OPC=<label>            
  vmovdqa %xmm1, %xmm1     #  1     0    4      OPC=vmovdqa_xmm_xmm    
  vcvtpd2dq %ymm1, %xmm12  #  2     0x4  4      OPC=vcvtpd2dq_xmm_ymm  
  vmovd %xmm12, %ebx       #  3     0x8  4      OPC=vmovd_r32_xmm      
  retq                     #  4     0xc  1      OPC=retq               
                                                                       
.size target, .-target
