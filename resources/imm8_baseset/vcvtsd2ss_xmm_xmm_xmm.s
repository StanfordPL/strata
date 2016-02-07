  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                        #  Line  RIP  Bytes  Opcode                  
.target:                      #        0    0      OPC=<label>             
  vmovdqa %xmm3, %xmm15       #  1     0    4      OPC=vmovdqa_xmm_xmm     
  vcvtpd2ps %ymm15, %xmm7     #  2     0x4  5      OPC=vcvtpd2ps_xmm_ymm   
  vmovss %xmm7, %xmm2, %xmm1  #  3     0x9  4      OPC=vmovss_xmm_xmm_xmm  
  retq                        #  4     0xd  1      OPC=retq                
                                                                           
.size target, .-target
