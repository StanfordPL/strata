  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text               #  Line  RIP   Bytes  Opcode              
.target:             #        0     0      OPC=<label>         
  movslq %eax, %rcx  #  1     0     3      OPC=movslq_r64_r32  
  movq $0x6, %rax    #  2     0x3   10     OPC=movq_r64_imm64  
  sall $0x1, %eax    #  3     0xd   2      OPC=sall_r32_one    
  xchgq %rcx, %rax   #  4     0xf   2      OPC=xchgq_rax_r64   
  retq               #  5     0x11  1      OPC=retq            
                                                               
.size target, .-target
