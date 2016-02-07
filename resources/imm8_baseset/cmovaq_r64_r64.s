  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                #  Line  RIP  Bytes  Opcode               
.target:              #        0    0      OPC=<label>          
  cmovnaq %rbx, %rcx  #  1     0    4      OPC=cmovnaq_r64_r64  
  movq %rcx, %rbx     #  2     0x4  3      OPC=movq_r64_r64     
  retq                #  3     0x7  1      OPC=retq             
                                                                
.size target, .-target
