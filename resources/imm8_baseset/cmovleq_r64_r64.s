  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                 #  Line  RIP  Bytes  Opcode                
.target:               #        0    0      OPC=<label>           
  movq %rbx, %rbx      #  1     0    3      OPC=movq_r64_r64      
  xchgq %rbx, %rcx     #  2     0x3  3      OPC=xchgq_r64_r64     
  cmovnleq %rcx, %rbx  #  3     0x6  4      OPC=cmovnleq_r64_r64  
  retq                 #  4     0xa  1      OPC=retq              
                                                                  
.size target, .-target
