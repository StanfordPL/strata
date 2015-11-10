  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text              #  Line  RIP  Bytes  Opcode             
.target:            #        0    0      OPC=<label>        
  movq %rdx, %rax   #  1     0    3      OPC=movq_r64_r64   
  mulq %rcx         #  2     0x3  3      OPC=mulq_r64       
  movq %rax, %rbx   #  3     0x6  3      OPC=movq_r64_r64   
  xchgq %rdx, %rax  #  4     0x9  2      OPC=xchgq_rax_r64  
  retq              #  5     0xb  1      OPC=retq           
                                                            
.size target, .-target
