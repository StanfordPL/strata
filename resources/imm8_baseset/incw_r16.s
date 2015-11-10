  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP   Bytes  Opcode              
.target:                            #        0     0      OPC=<label>         
  movw %bx, %r11w                   #  1     0     4      OPC=movw_r16_r16    
  movq $0x1, %rbx                   #  2     0x4   10     OPC=movq_r64_imm64  
  callq .move_016_008_bx_r8b_r9b    #  3     0xe   5      OPC=callq_label     
  callq .move_r8b_to_byte_3_of_rbx  #  4     0x13  5      OPC=callq_label     
  addw %r11w, %bx                   #  5     0x18  4      OPC=addw_r16_r16    
  retq                              #  6     0x1c  1      OPC=retq            
                                                                              
.size target, .-target
