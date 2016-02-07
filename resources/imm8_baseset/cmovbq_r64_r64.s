  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text               #  Line  RIP  Bytes  Opcode              
.target:             #        0    0      OPC=<label>         
  setnb %r15b        #  1     0    4      OPC=setnb_r8        
  salb $0x1, %r15b   #  2     0x4  3      OPC=salb_r8_one     
  cmoveq %rcx, %rbx  #  3     0x7  4      OPC=cmoveq_r64_r64  
  retq               #  4     0xb  1      OPC=retq            
                                                              
.size target, .-target
