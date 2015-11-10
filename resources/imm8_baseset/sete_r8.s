  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                             #  Line  RIP  Bytes  Opcode           
.target:                           #        0    0      OPC=<label>      
  callq .read_zf_into_rcx          #  1     0    5      OPC=callq_label  
  callq .move_032_016_ecx_r8w_r9w  #  2     0x5  5      OPC=callq_label  
  callq .move_008_016_r8b_r9b_bx   #  3     0xa  5      OPC=callq_label  
  retq                             #  4     0xf  1      OPC=retq         
                                                                         
.size target, .-target
