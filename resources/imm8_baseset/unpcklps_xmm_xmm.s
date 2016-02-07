  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                                 #  Line  RIP   Bytes  Opcode                  
.target:                               #        0     0      OPC=<label>             
  vmovshdup %xmm1, %xmm15              #  1     0     4      OPC=vmovshdup_xmm_xmm   
  vmovsldup %xmm2, %xmm10              #  2     0x4   4      OPC=vmovsldup_xmm_xmm   
  vmovss %xmm15, %xmm2, %xmm11         #  3     0x8   5      OPC=vmovss_xmm_xmm_xmm  
  movss %xmm1, %xmm10                  #  4     0xd   5      OPC=movss_xmm_xmm       
  callq .move_64_128_xmm10_xmm11_xmm1  #  5     0x12  5      OPC=callq_label         
  retq                                 #  6     0x17  1      OPC=retq                
                                                                                     
.size target, .-target
