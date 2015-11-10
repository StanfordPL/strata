  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                               #  Line  RIP   Bytes  Opcode                 
.target:                             #        0     0      OPC=<label>            
  movq $0xfffffffffffffffa, %rbx     #  1     0     10     OPC=movq_r64_imm64     
  callq .move_byte_0_of_ymm1_to_r8b  #  2     0xa   5      OPC=callq_label        
  callq .move_r8b_to_byte_4_of_rbx   #  3     0xf   5      OPC=callq_label        
  cvtsd2sil %xmm1, %r12d             #  4     0x14  5      OPC=cvtsd2sil_r32_xmm  
  xchgl %ebx, %r12d                  #  5     0x19  3      OPC=xchgl_r32_r32      
  retq                               #  6     0x1c  1      OPC=retq               
                                                                                  
.size target, .-target
