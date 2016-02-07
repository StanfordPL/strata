  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                               #  Line  RIP   Bytes  Opcode              
.target:                             #        0     0      OPC=<label>         
  callq .move_032_016_ebx_r10w_r11w  #  1     0     5      OPC=callq_label     
  callq .move_016_008_bx_r8b_r9b     #  2     0x5   5      OPC=callq_label     
  movswl %r11w, %ebx                 #  3     0xa   4      OPC=movswl_r32_r16  
  xchgb %bh, %bl                     #  4     0xe   2      OPC=xchgb_r8_rh     
  callq .move_r8b_to_byte_3_of_rbx   #  5     0x10  5      OPC=callq_label     
  callq .move_r9b_to_byte_2_of_rbx   #  6     0x15  5      OPC=callq_label     
  retq                               #  7     0x1a  1      OPC=retq            
                                                                               
.size target, .-target
