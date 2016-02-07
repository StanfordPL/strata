  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                               #  Line  RIP  Bytes  Opcode               
.target:                             #        0    0      OPC=<label>          
  callq .move_064_032_rbx_r12d_r13d  #  1     0    5      OPC=callq_label      
  cmovnpl %r12d, %ecx                #  2     0x5  4      OPC=cmovnpl_r32_r32  
  orb %bh, %bh                       #  3     0x9  2      OPC=orb_rh_rh        
  cmovncl %ecx, %ebx                 #  4     0xb  3      OPC=cmovncl_r32_r32  
  retq                               #  5     0xe  1      OPC=retq             
                                                                               
.size target, .-target
