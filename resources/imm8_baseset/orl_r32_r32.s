  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                              #  Line  RIP   Bytes  Opcode             
.target:                            #        0     0      OPC=<label>        
  xchgl %ebx, %ecx                  #  1     0     2      OPC=xchgl_r32_r32  
  callq .move_064_032_rcx_r8d_r9d   #  2     0x2   5      OPC=callq_label    
  callq .move_r8b_to_byte_4_of_rbx  #  3     0x7   5      OPC=callq_label    
  xchgl %r8d, %r8d                  #  4     0xc   3      OPC=xchgl_r32_r32  
  orq %rbx, %r8                     #  5     0xf   3      OPC=orq_r64_r64    
  callq .move_032_064_r8d_r9d_rbx   #  6     0x12  5      OPC=callq_label    
  callq .set_szp_for_ebx            #  7     0x17  5      OPC=callq_label    
  retq                              #  8     0x1c  1      OPC=retq           
                                                                             
.size target, .-target
