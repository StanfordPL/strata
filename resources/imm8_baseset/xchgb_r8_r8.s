  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text               #  Line  RIP  Bytes  Opcode             
.target:             #        0    0      OPC=<label>        
  movsbq %bl, %rsi   #  1     0    4      OPC=movsbq_r64_r8  
  movsbq %cl, %rbx   #  2     0x4  4      OPC=movsbq_r64_r8  
  movsbq %sil, %rcx  #  3     0x8  4      OPC=movsbq_r64_r8  
  retq               #  4     0xc  1      OPC=retq           
                                                             
.size target, .-target
