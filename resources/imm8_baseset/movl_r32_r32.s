  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text              #  Line  RIP  Bytes  Opcode              
.target:            #        0    0      OPC=<label>         
  movq $0x4, %rbx   #  1     0    10     OPC=movq_r64_imm64  
  xchgl %ebx, %ecx  #  2     0xa  2      OPC=xchgl_r32_r32   
  retq              #  3     0xc  1      OPC=retq            
                                                             
.size target, .-target
