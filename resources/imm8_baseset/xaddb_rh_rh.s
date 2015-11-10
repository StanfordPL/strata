  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                               #  Line  RIP   Bytes  Opcode             
.target:                             #        0     0      OPC=<label>        
  movzbl %bh, %ebx                   #  1     0     3      OPC=movzbl_r32_rh  
  callq .move_032_016_ebx_r12w_r13w  #  2     0x3   5      OPC=callq_label    
  callq .move_008_016_r12b_r13b_bx   #  3     0x8   5      OPC=callq_label    
  xaddb %bl, %ah                     #  4     0xd   3      OPC=xaddb_rh_r8    
  xchgb %bl, %bh                     #  5     0x10  2      OPC=xchgb_rh_r8    
  retq                               #  6     0x12  1      OPC=retq           
                                                                              
.size target, .-target
