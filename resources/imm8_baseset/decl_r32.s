  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text              #  Line  RIP   Bytes  Opcode              
.target:            #        0     0      OPC=<label>         
  movl %ebx, %eax   #  1     0     2      OPC=movl_r32_r32    
  xaddl %ebx, %eax  #  2     0x2   3      OPC=xaddl_r32_r32   
  movq $0x1, %rax   #  3     0x5   10     OPC=movq_r64_imm64  
  subl %eax, %ebx   #  4     0xf   2      OPC=subl_r32_r32    
  retq              #  5     0x11  1      OPC=retq            
                                                              
.size target, .-target
