  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                #  Line  RIP  Bytes  Opcode               
.target:              #        0    0      OPC=<label>          
  movzwq %bx, %rax    #  1     0    4      OPC=movzwq_r64_r16   
  movzwl %cx, %r13d   #  2     0x4  4      OPC=movzwl_r32_r16   
  xchgl %r13d, %eax   #  3     0x8  2      OPC=xchgl_eax_r32    
  cmovnbl %eax, %ebx  #  4     0xa  3      OPC=cmovnbl_r32_r32  
  retq                #  5     0xd  1      OPC=retq             
                                                                
.size target, .-target
