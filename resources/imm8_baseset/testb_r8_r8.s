  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text               #  Line  RIP  Bytes  Opcode             
.target:             #        0    0      OPC=<label>        
  movsbl %cl, %r10d  #  1     0    4      OPC=movsbl_r32_r8  
  movsbq %bl, %r15   #  2     0x4  4      OPC=movsbq_r64_r8  
  andl %r15d, %r10d  #  3     0x8  3      OPC=andl_r32_r32   
  retq               #  4     0xb  1      OPC=retq           
                                                             
.size target, .-target
