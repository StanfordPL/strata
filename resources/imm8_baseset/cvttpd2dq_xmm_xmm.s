  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                         #  Line  RIP  Bytes  Opcode                  
.target:                       #        0    0      OPC=<label>             
  vminsd %xmm2, %xmm2, %xmm15  #  1     0    4      OPC=vminsd_xmm_xmm_xmm  
  vcvttpd2dq %ymm15, %xmm7     #  2     0x4  5      OPC=vcvttpd2dq_xmm_ymm  
  movdqu %xmm7, %xmm1          #  3     0x9  4      OPC=movdqu_xmm_xmm      
  retq                         #  4     0xd  1      OPC=retq                
                                                                            
.size target, .-target
