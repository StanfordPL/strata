  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                                      #  Line  RIP  Bytes  Opcode                  
.target:                                    #        0    0      OPC=<label>             
  vmovapd %xmm1, %xmm5                      #  1     0    4      OPC=vmovapd_xmm_xmm     
  vcvttpd2dq %ymm5, %xmm1                   #  2     0x4  4      OPC=vcvttpd2dq_xmm_ymm  
  callq .move_128_032_xmm1_eax_edx_r8d_r9d  #  3     0x8  5      OPC=callq_label         
  movl %eax, %ebx                           #  4     0xd  2      OPC=movl_r32_r32        
  retq                                      #  5     0xf  1      OPC=retq                
                                                                                         
.size target, .-target
