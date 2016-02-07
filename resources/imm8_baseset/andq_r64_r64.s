  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                            #  Line  RIP   Bytes  Opcode                      
.target:                          #        0     0      OPC=<label>                 
  movq %rcx, %xmm1                #  1     0     5      OPC=movq_xmm_r64            
  vmovq %rbx, %xmm5               #  2     0x5   5      OPC=vmovq_xmm_r64           
  vandpd %xmm1, %xmm5, %xmm13     #  3     0xa   4      OPC=vandpd_xmm_xmm_xmm      
  movq %xmm13, %rbx               #  4     0xe   5      OPC=movq_r64_xmm            
  vpunpckhdq %xmm1, %xmm5, %xmm6  #  5     0x13  4      OPC=vpunpckhdq_xmm_xmm_xmm  
  movd %xmm6, %r8d                #  6     0x17  5      OPC=movd_r32_xmm            
  addq %r8, %rbx                  #  7     0x1c  3      OPC=addq_r64_r64            
  retq                            #  8     0x1f  1      OPC=retq                    
                                                                                    
.size target, .-target
