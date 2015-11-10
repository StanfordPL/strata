  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                   #  Line  RIP  Bytes  Opcode              
.target:                 #        0    0      OPC=<label>         
  movswl %cx, %edx       #  1     0    3      OPC=movswl_r32_r16  
  movswl %bx, %ebx       #  2     0x3  3      OPC=movswl_r32_r16  
  orl %edx, %ebx         #  3     0x6  2      OPC=orl_r32_r32     
  callq .set_szp_for_bx  #  4     0x8  5      OPC=callq_label     
  retq                   #  5     0xd  1      OPC=retq            
                                                                  
.size target, .-target
