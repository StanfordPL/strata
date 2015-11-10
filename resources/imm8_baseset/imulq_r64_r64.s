  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text              #  Line  RIP  Bytes  Opcode             
.target:            #        0    0      OPC=<label>        
  movq %rbx, %rax   #  1     0    3      OPC=movq_r64_r64   
  imulq %rcx        #  2     0x3  3      OPC=imulq_r64      
  xchgq %rbx, %rax  #  3     0x6  2      OPC=xchgq_rax_r64  
  retq              #  4     0x8  1      OPC=retq           
                                                            
.size target, .-target
