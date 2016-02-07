  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                #  Line  RIP  Bytes  Opcode              
.target:              #        0    0      OPC=<label>         
  movzbl %cl, %r15d   #  1     0    4      OPC=movzbl_r32_r8   
  movswq %r15w, %rbx  #  2     0x4  4      OPC=movswq_r64_r16  
  retq                #  3     0x8  1      OPC=retq            
                                                               
.size target, .-target
