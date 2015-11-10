  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP  Bytes  Opcode              
.target:                            #        0    0      OPC=<label>         
  callq .move_016_008_bx_r10b_r11b  #  1     0    5      OPC=callq_label     
  callq .move_008_016_r10b_r11b_bx  #  2     0x5  5      OPC=callq_label     
  cmovzl %ecx, %ebx                 #  3     0xa  3      OPC=cmovzl_r32_r32  
  retq                              #  4     0xd  1      OPC=retq            
                                                                             
.size target, .-target
