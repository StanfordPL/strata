  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP   Bytes  Opcode            
.target:                            #        0     0      OPC=<label>       
  movw %bx, %dx                     #  1     0     3      OPC=movw_r16_r16  
  notw %bx                          #  2     0x3   3      OPC=notw_r16      
  incw %bx                          #  3     0x6   3      OPC=incw_r16      
  callq .move_016_008_dx_r12b_r13b  #  4     0x9   5      OPC=callq_label   
  orb %bl, %r13b                    #  5     0xe   3      OPC=orb_r8_r8     
  adcw %bx, %dx                     #  6     0x11  3      OPC=adcw_r16_r16  
  callq .set_szp_for_bx             #  7     0x14  5      OPC=callq_label   
  retq                              #  8     0x19  1      OPC=retq          
                                                                            
.size target, .-target
