  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                            #  Line  RIP   Bytes  Opcode              
.target:                          #        0     0      OPC=<label>         
  movsbl %cl, %r14d               #  1     0     4      OPC=movsbl_r32_r8   
  movq $0xfffffffffffffffb, %rdx  #  2     0x4   10     OPC=movq_r64_imm64  
  movswq %dx, %rbx                #  3     0xe   4      OPC=movswq_r64_r16  
  xchgl %ebx, %r14d               #  4     0x12  3      OPC=xchgl_r32_r32   
  retq                            #  5     0x15  1      OPC=retq            
                                                                            
.size target, .-target
