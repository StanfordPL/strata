  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text               #  Line  RIP  Bytes  Opcode              
.target:             #        0    0      OPC=<label>         
  setg %r13b         #  1     0    4      OPC=setg_r8         
  orb %r13b, %r13b   #  2     0x4  3      OPC=orb_r8_r8       
  cmovel %ecx, %ebx  #  3     0x7  3      OPC=cmovel_r32_r32  
  retq               #  4     0xa  1      OPC=retq            
                                                              
.size target, .-target
