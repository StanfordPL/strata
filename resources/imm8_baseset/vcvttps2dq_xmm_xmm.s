  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                      #  Line  RIP  Bytes  Opcode                  
.target:                    #        0    0      OPC=<label>             
  vmovupd %xmm2, %xmm13     #  1     0    4      OPC=vmovupd_xmm_xmm     
  vcvttps2dq %ymm13, %ymm4  #  2     0x4  5      OPC=vcvttps2dq_ymm_ymm  
  vmovdqu %xmm4, %xmm1      #  3     0x9  4      OPC=vmovdqu_xmm_xmm     
  retq                      #  4     0xd  1      OPC=retq                
                                                                         
.size target, .-target
