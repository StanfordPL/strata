  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                     #  Line  RIP  Bytes  Opcode                 
.target:                   #        0    0      OPC=<label>            
  notw %cx                 #  1     0    3      OPC=notw_r16           
  shlxl %ecx, %ebx, %r13d  #  2     0x3  5      OPC=shlxl_r32_r32_r32  
  shll $0x1, %r13d         #  3     0x8  3      OPC=shll_r32_one       
  retq                     #  4     0xb  1      OPC=retq               
                                                                       
.size target, .-target
