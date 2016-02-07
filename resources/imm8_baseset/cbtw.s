  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                            #  Line  RIP   Bytes  Opcode              
.target:                          #        0     0      OPC=<label>         
  movsbq %al, %rdx                #  1     0     4      OPC=movsbq_r64_r8   
  movq $0xfffffffffffffff0, %rax  #  2     0x4   10     OPC=movq_r64_imm64  
  xchgl %eax, %edx                #  3     0xe   2      OPC=xchgl_r32_r32   
  retq                            #  4     0x10  1      OPC=retq            
                                                                            
.size target, .-target
