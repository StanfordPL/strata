  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                               #  Line  RIP   Bytes  Opcode            
.target:                             #        0     0      OPC=<label>       
  callq .move_064_032_rbx_r10d_r11d  #  1     0     5      OPC=callq_label   
  xorq %rax, %rax                    #  2     0x5   3      OPC=xorq_r64_r64  
  adcq %rcx, %rbx                    #  3     0x8   3      OPC=adcq_r64_r64  
  callq .move_032_064_r10d_r11d_rcx  #  4     0xb   5      OPC=callq_label   
  retq                               #  5     0x10  1      OPC=retq          
                                                                             
.size target, .-target
