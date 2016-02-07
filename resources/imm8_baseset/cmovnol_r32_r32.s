  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP   Bytes  Opcode              
.target:                            #        0     0      OPC=<label>         
  vmovd %ecx, %xmm14                #  1     0     4      OPC=vmovd_xmm_r32   
  vmovq %xmm14, %xmm1               #  2     0x4   5      OPC=vmovq_xmm_xmm   
  callq .read_of_into_rcx           #  3     0x9   5      OPC=callq_label     
  salb $0x1, %cl                    #  4     0xe   2      OPC=salb_r8_one     
  callq .move_128_064_xmm1_r10_r11  #  5     0x10  5      OPC=callq_label     
  cmovzl %r10d, %ebx                #  6     0x15  4      OPC=cmovzl_r32_r32  
  retq                              #  7     0x19  1      OPC=retq            
                                                                              
.size target, .-target
