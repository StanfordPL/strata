  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text               #  Line  RIP  Bytes  Opcode              
.target:             #        0    0      OPC=<label>         
  movzbl %bl, %r9d   #  1     0    4      OPC=movzbl_r32_r8   
  movswl %r9w, %ebx  #  2     0x4  4      OPC=movswl_r32_r16  
  movzbl %cl, %r10d  #  3     0x8  4      OPC=movzbl_r32_r8   
  subb %r10b, %bl    #  4     0xc  3      OPC=subb_r8_r8      
  retq               #  5     0xf  1      OPC=retq            
                                                              
.size target, .-target
