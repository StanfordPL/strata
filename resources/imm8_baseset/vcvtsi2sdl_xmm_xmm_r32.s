  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                     #  Line  RIP  Bytes  Opcode                  
.target:                   #        0    0      OPC=<label>             
  vmovq %xmm2, %xmm1       #  1     0    4      OPC=vmovq_xmm_xmm       
  punpckhqdq %xmm2, %xmm1  #  2     0x4  4      OPC=punpckhqdq_xmm_xmm  
  cvtsi2sdl %ebx, %xmm1    #  3     0x8  4      OPC=cvtsi2sdl_xmm_r32   
  retq                     #  4     0xc  1      OPC=retq                
                                                                        
.size target, .-target
