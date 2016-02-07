  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                           #  Line  RIP   Bytes  Opcode              
.target:                         #        0     0      OPC=<label>         
  movq $0xffffffffffffffff, %r9  #  1     0     10     OPC=movq_r64_imm64  
  rolb $0x1, %r9b                #  2     0xa   3      OPC=rolb_r8_one     
  xaddl %r9d, %ebx               #  3     0xd   4      OPC=xaddl_r32_r32   
  retq                           #  4     0x11  1      OPC=retq            
                                                                           
.size target, .-target
