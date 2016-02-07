  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP   Bytes  Opcode               
.target:                            #        0     0      OPC=<label>          
  vmovd %ebx, %xmm1                 #  1     0     4      OPC=vmovd_xmm_r32    
  callq .move_128_064_xmm1_r12_r13  #  2     0x4   5      OPC=callq_label      
  cmovnll %r12d, %ecx               #  3     0x9   4      OPC=cmovnll_r32_r32  
  xaddl %ebx, %ecx                  #  4     0xd   3      OPC=xaddl_r32_r32    
  retq                              #  5     0x10  1      OPC=retq             
                                                                               
.size target, .-target
