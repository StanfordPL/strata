  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text             #  Line  RIP  Bytes  Opcode              
.target:           #        0    0      OPC=<label>         
  movq $0x6, %rbx  #  1     0    10     OPC=movq_r64_imm64  
  xchgb %cl, %bl   #  2     0xa  2      OPC=xchgb_r8_r8     
  retq             #  3     0xc  1      OPC=retq            
                                                            
.size target, .-target
