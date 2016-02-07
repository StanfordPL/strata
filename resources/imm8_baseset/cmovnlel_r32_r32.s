  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                #  Line  RIP   Bytes  Opcode              
.target:              #        0     0      OPC=<label>         
  movl %ebx, %r10d    #  1     0     3      OPC=movl_r32_r32    
  movl %r10d, %r10d   #  2     0x3   3      OPC=movl_r32_r32    
  movslq %ecx, %r14   #  3     0x6   3      OPC=movslq_r64_r32  
  movq %r14, %rdi     #  4     0x9   3      OPC=movq_r64_r64    
  cmovgl %edi, %r10d  #  5     0xc   4      OPC=cmovgl_r32_r32  
  xchgl %r10d, %ebx   #  6     0x10  3      OPC=xchgl_r32_r32   
  retq                #  7     0x13  1      OPC=retq            
                                                                
.size target, .-target
