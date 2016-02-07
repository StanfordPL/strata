  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text              #  Line  RIP  Bytes  Opcode              
.target:            #        0    0      OPC=<label>         
  movswq %cx, %rdi  #  1     0    4      OPC=movswq_r64_r16  
  movswq %bx, %r11  #  2     0x4  4      OPC=movswq_r64_r16  
  xorq %r11, %rdi   #  3     0x8  3      OPC=xorq_r64_r64    
  movswq %di, %rbx  #  4     0xb  4      OPC=movswq_r64_r16  
  retq              #  5     0xf  1      OPC=retq            
                                                             
.size target, .-target
