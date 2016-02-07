  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                      #  Line  RIP  Bytes  Opcode                 
.target:                    #        0    0      OPC=<label>            
  vmovups %xmm2, %xmm10     #  1     0    4      OPC=vmovups_xmm_xmm    
  vcvtpd2dq %ymm10, %xmm14  #  2     0x4  5      OPC=vcvtpd2dq_xmm_ymm  
  movupd %xmm14, %xmm1      #  3     0x9  5      OPC=movupd_xmm_xmm     
  retq                      #  4     0xe  1      OPC=retq               
                                                                        
.size target, .-target
