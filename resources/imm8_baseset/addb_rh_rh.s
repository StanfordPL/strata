  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                              #  Line  RIP   Bytes  Opcode            
.target:                            #        0     0      OPC=<label>       
  movb %ah, %bl                     #  1     0     2      OPC=movb_r8_rh    
  callq .move_016_008_bx_r10b_r11b  #  2     0x2   5      OPC=callq_label   
  xaddb %bl, %r11b                  #  3     0x7   4      OPC=xaddb_r8_r8   
  callq .move_008_016_r10b_r11b_cx  #  4     0xb   5      OPC=callq_label   
  movw %cx, %ax                     #  5     0x10  3      OPC=movw_r16_r16  
  retq                              #  6     0x13  1      OPC=retq          
                                                                            
.size target, .-target
