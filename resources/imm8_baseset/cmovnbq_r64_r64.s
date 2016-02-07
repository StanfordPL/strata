  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text               #  Line  RIP  Bytes  Opcode              
.target:             #        0    0      OPC=<label>         
  setb %al           #  1     0    3      OPC=setb_r8         
  xaddb %al, %al     #  2     0x3  3      OPC=xaddb_r8_r8     
  cmovzq %rcx, %rbx  #  3     0x6  4      OPC=cmovzq_r64_r64  
  retq               #  4     0xa  1      OPC=retq            
                                                              
.size target, .-target
