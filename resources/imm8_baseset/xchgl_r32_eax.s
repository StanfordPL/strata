  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    2 bytes

# Text                               #  Line  RIP   Bytes  Opcode              
.target:                             #        0     0      OPC=<label>         
  callq .move_032_016_ebx_r12w_r13w  #  1     0     5      OPC=callq_label     
  movslq %eax, %rcx                  #  2     0x5   3      OPC=movslq_r64_r32  
  callq .move_016_032_r12w_r13w_ecx  #  3     0x8   5      OPC=callq_label     
  callq .move_064_032_rcx_r8d_r9d    #  4     0xd   5      OPC=callq_label     
  movslq %eax, %r8                   #  5     0x12  3      OPC=movslq_r64_r32  
  callq .move_032_064_r8d_r9d_rbx    #  6     0x15  5      OPC=callq_label     
  movq %rcx, %rax                    #  7     0x1a  3      OPC=movq_r64_r64    
  retq                               #  8     0x1d  1      OPC=retq            
                                                                               
.size target, .-target
