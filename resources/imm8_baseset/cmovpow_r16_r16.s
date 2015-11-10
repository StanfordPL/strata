  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                     #  Line  RIP   Bytes  Opcode              
.target:                   #        0     0      OPC=<label>         
  movzwq %cx, %rax         #  1     0     4      OPC=movzwq_r64_r16  
  callq .read_pf_into_rcx  #  2     0x4   5      OPC=callq_label     
  salw $0x1, %cx           #  3     0x9   3      OPC=salw_r16_one    
  movzwl %ax, %r15d        #  4     0xc   4      OPC=movzwl_r32_r16  
  cmovzq %r15, %rbx        #  5     0x10  4      OPC=cmovzq_r64_r64  
  retq                     #  6     0x14  1      OPC=retq            
                                                                     
.size target, .-target
