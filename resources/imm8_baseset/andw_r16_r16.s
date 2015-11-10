  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                   #  Line  RIP   Bytes  Opcode              
.target:                 #        0     0      OPC=<label>         
  movswq %cx, %r11       #  1     0     4      OPC=movswq_r64_r16  
  movzwl %bx, %r9d       #  2     0x4   4      OPC=movzwl_r32_r16  
  andl %r11d, %r9d       #  3     0x8   3      OPC=andl_r32_r32    
  callq .clear_of        #  4     0xb   5      OPC=callq_label     
  movq %r9, %rbx         #  5     0x10  3      OPC=movq_r64_r64    
  callq .set_szp_for_bx  #  6     0x13  5      OPC=callq_label     
  retq                   #  7     0x18  1      OPC=retq            
                                                                   
.size target, .-target
