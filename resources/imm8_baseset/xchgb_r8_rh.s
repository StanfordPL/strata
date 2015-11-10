  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                              #  Line  RIP   Bytes  Opcode             
.target:                            #        0     0      OPC=<label>        
  movzbw %ah, %dx                   #  1     0     4      OPC=movzbw_r16_rh  
  xaddb %ah, %bl                    #  2     0x4   3      OPC=xaddb_r8_rh    
  callq .move_016_008_dx_r10b_r11b  #  3     0x7   5      OPC=callq_label    
  salb $0x1, %r11b                  #  4     0xc   3      OPC=salb_r8_one    
  setno %bh                         #  5     0xf   3      OPC=setno_rh       
  xchgw %bx, %dx                    #  6     0x12  3      OPC=xchgw_r16_r16  
  retq                              #  7     0x15  1      OPC=retq           
                                                                             
.size target, .-target
