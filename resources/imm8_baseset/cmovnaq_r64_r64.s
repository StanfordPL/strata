  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text               #  Line  RIP  Bytes  Opcode              
.target:             #        0    0      OPC=<label>         
  setbe %r12b        #  1     0    4      OPC=setbe_r8        
  decb %r12b         #  2     0x4  3      OPC=decb_r8         
  cmovzq %rcx, %rbx  #  3     0x7  4      OPC=cmovzq_r64_r64  
  retq               #  4     0xb  1      OPC=retq            
                                                              
.size target, .-target
