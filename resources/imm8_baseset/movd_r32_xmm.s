  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                             #  Line  RIP   Bytes  Opcode                  
.target:                           #        0     0      OPC=<label>             
  cvttss2siq %xmm1, %rbx           #  1     0     5      OPC=cvttss2siq_r64_xmm  
  callq .move_128_064_xmm1_r8_r9   #  2     0x5   5      OPC=callq_label         
  callq .move_032_064_r8d_r9d_rcx  #  3     0xa   5      OPC=callq_label         
  callq .move_032_016_ecx_r8w_r9w  #  4     0xf   5      OPC=callq_label         
  callq .move_016_032_r8w_r9w_ebx  #  5     0x14  5      OPC=callq_label         
  retq                             #  6     0x19  1      OPC=retq                
                                                                                 
.size target, .-target
