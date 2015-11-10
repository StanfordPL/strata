  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                               #  Line  RIP   Bytes  Opcode             
.target:                             #        0     0      OPC=<label>        
  movsbw %ah, %ax                    #  1     0     4      OPC=movsbw_r16_rh  
  movsbq %al, %r12                   #  2     0x4   4      OPC=movsbq_r64_r8  
  movsbq %r12b, %rbx                 #  3     0x8   4      OPC=movsbq_r64_r8  
  callq .move_032_016_ebx_r12w_r13w  #  4     0xc   5      OPC=callq_label    
  callq .move_016_032_r12w_r13w_ebx  #  5     0x11  5      OPC=callq_label    
  retq                               #  6     0x16  1      OPC=retq           
                                                                              
.size target, .-target
