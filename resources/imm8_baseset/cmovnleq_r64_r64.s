  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text               #  Line  RIP  Bytes  Opcode              
.target:             #        0    0      OPC=<label>         
  setng %bpl         #  1     0    4      OPC=setng_r8        
  orb %bpl, %bpl     #  2     0x4  3      OPC=orb_r8_r8       
  cmovzq %rcx, %rbx  #  3     0x7  4      OPC=cmovzq_r64_r64  
  retq               #  4     0xb  1      OPC=retq            
                                                              
.size target, .-target
