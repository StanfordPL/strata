  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                            #  Line  RIP  Bytes  Opcode                      
.target:                          #        0    0      OPC=<label>                 
  movslq %ebx, %rbx               #  1     0    3      OPC=movslq_r64_r32          
  vcvtsi2sdq %rbx, %xmm1, %xmm11  #  2     0x3  5      OPC=vcvtsi2sdq_xmm_xmm_r64  
  movdqa %xmm11, %xmm1            #  3     0x8  5      OPC=movdqa_xmm_xmm          
  retq                            #  4     0xd  1      OPC=retq                    
                                                                                   
.size target, .-target
