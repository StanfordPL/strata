  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text              #  Line  RIP  Bytes  Opcode              
.target:            #        0    0      OPC=<label>         
  movzwq %cx, %rax  #  1     0    4      OPC=movzwq_r64_r16  
  movzbl %ah, %ebx  #  2     0x4  3      OPC=movzbl_r32_rh   
  movw %ax, %bx     #  3     0x7  3      OPC=movw_r16_r16    
  retq              #  4     0xa  1      OPC=retq            
                                                             
.size target, .-target
