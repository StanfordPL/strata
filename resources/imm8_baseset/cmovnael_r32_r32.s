  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP  Bytes  Opcode               
.target:                            #        0    0      OPC=<label>          
  vmovd %ebx, %xmm1                 #  1     0    4      OPC=vmovd_xmm_r32    
  callq .move_128_064_xmm1_r10_r11  #  2     0x4  5      OPC=callq_label      
  adcl %r11d, %r11d                 #  3     0x9  3      OPC=adcl_r32_r32     
  cmovnzl %ecx, %ebx                #  4     0xc  3      OPC=cmovnzl_r32_r32  
  retq                              #  5     0xf  1      OPC=retq             
                                                                              
.size target, .-target
