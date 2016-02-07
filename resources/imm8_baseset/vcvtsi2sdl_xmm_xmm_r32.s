  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                        #  Line  RIP  Bytes  Opcode                  
.target:                      #        0    0      OPC=<label>             
  vmovd %ebx, %xmm3           #  1     0    4      OPC=vmovd_xmm_r32       
  vcvtdq2pd %ymm3, %ymm6      #  2     0x4  4      OPC=vcvtdq2pd_ymm_ymm   
  vmovsd %xmm6, %xmm2, %xmm1  #  3     0x8  4      OPC=vmovsd_xmm_xmm_xmm  
  retq                        #  4     0xc  1      OPC=retq                
                                                                           
.size target, .-target
