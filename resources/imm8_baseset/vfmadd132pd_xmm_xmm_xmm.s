  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                              #  Line  RIP   Bytes  Opcode                       
.target:                            #        0     0      OPC=<label>                  
  vmovsd %xmm1, %xmm1, %xmm5        #  1     0     4      OPC=vmovsd_xmm_xmm_xmm       
  vmovups %xmm3, %xmm1              #  2     0x4   4      OPC=vmovups_xmm_xmm          
  vmaxss %xmm2, %xmm2, %xmm15       #  3     0x8   4      OPC=vmaxss_xmm_xmm_xmm       
  vfmadd132pd %ymm1, %ymm15, %ymm5  #  4     0xc   5      OPC=vfmadd132pd_ymm_ymm_ymm  
  movups %xmm5, %xmm1               #  5     0x11  3      OPC=movups_xmm_xmm           
  retq                              #  6     0x14  1      OPC=retq                     
                                                                                       
.size target, .-target
