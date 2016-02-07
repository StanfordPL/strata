  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                            #  Line  RIP  Bytes  Opcode           
.target:                          #        0    0      OPC=<label>      
  movb %ah, %bh                   #  1     0    2      OPC=movb_rh_rh   
  callq .move_016_008_bx_r8b_r9b  #  2     0x2  5      OPC=callq_label  
  addb %r9b, %bl                  #  3     0x7  3      OPC=addb_r8_r8   
  retq                            #  4     0xa  1      OPC=retq         
                                                                        
.size target, .-target
