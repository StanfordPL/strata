  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text              #  Line  RIP  Bytes  Opcode              
.target:            #        0    0      OPC=<label>         
  movb %bl, %bh     #  1     0    2      OPC=movb_rh_r8      
  movb %ah, %bl     #  2     0x2  2      OPC=movb_r8_rh      
  movzwq %bx, %rax  #  3     0x4  4      OPC=movzwq_r64_r16  
  retq              #  4     0x8  1      OPC=retq            
                                                             
.size target, .-target
