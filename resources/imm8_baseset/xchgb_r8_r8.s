  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                             #  Line  RIP   Bytes  Opcode             
.target:                           #        0     0      OPC=<label>        
  movsbq %cl, %rdx                 #  1     0     4      OPC=movsbq_r64_r8  
  xaddb %cl, %bl                   #  2     0x4   3      OPC=xaddb_r8_r8    
  callq .move_032_016_edx_r8w_r9w  #  3     0x7   5      OPC=callq_label    
  callq .move_016_032_r8w_r9w_ebx  #  4     0xc   5      OPC=callq_label    
  retq                             #  5     0x11  1      OPC=retq           
                                                                            
.size target, .-target
