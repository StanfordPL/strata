  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                            #  Line  RIP   Bytes  Opcode             
.target:                          #        0     0      OPC=<label>        
  movzbw %ah, %dx                 #  1     0     4      OPC=movzbw_r16_rh  
  callq .move_016_008_dx_r8b_r9b  #  2     0x4   5      OPC=callq_label    
  xaddb %bl, %dl                  #  3     0x9   3      OPC=xaddb_r8_r8    
  movb %dl, %ah                   #  4     0xc   2      OPC=movb_rh_r8     
  callq .move_008_016_r8b_r9b_bx  #  5     0xe   5      OPC=callq_label    
  retq                            #  6     0x13  1      OPC=retq           
                                                                           
.size target, .-target
