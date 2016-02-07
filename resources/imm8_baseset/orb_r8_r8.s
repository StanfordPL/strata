  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                   #  Line  RIP   Bytes  Opcode             
.target:                 #        0     0      OPC=<label>        
  movzbl %cl, %r13d      #  1     0     4      OPC=movzbl_r32_r8  
  movzbq %bl, %r14       #  2     0x4   4      OPC=movzbq_r64_r8  
  orq %r14, %r13         #  3     0x8   3      OPC=orq_r64_r64    
  movzbq %r13b, %rbx     #  4     0xb   4      OPC=movzbq_r64_r8  
  callq .set_szp_for_bl  #  5     0xf   5      OPC=callq_label    
  callq .clear_cf        #  6     0x14  5      OPC=callq_label    
  retq                   #  7     0x19  1      OPC=retq           
                                                                  
.size target, .-target
