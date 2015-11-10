  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                            #  Line  RIP  Bytes  Opcode             
.target:                          #        0    0      OPC=<label>        
  vmovd %ebx, %xmm1               #  1     0    4      OPC=vmovd_xmm_r32  
  callq .move_128_064_xmm1_r8_r9  #  2     0x4  5      OPC=callq_label    
  subq %rbx, %r9                  #  3     0x9  3      OPC=subq_r64_r64   
  movq %r9, %rbx                  #  4     0xc  3      OPC=movq_r64_r64   
  retq                            #  5     0xf  1      OPC=retq           
                                                                          
.size target, .-target
