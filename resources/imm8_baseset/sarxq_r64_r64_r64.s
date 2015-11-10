  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                             #  Line  RIP   Bytes  Opcode             
.target:                           #        0     0      OPC=<label>        
  xchgq %rdx, %rcx                 #  1     0     3      OPC=xchgq_r64_r64  
  sarq %cl, %rdx                   #  2     0x3   3      OPC=sarq_r64_cl    
  callq .move_064_032_rdx_r8d_r9d  #  3     0x6   5      OPC=callq_label    
  callq .move_032_064_r8d_r9d_rbx  #  4     0xb   5      OPC=callq_label    
  retq                             #  5     0x10  1      OPC=retq           
                                                                            
.size target, .-target
