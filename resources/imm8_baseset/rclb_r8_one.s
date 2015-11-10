  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                            #  Line  RIP  Bytes  Opcode           
.target:                          #        0    0      OPC=<label>      
  setnb %bh                       #  1     0    3      OPC=setnb_rh     
  callq .move_016_008_bx_r8b_r9b  #  2     0x3  5      OPC=callq_label  
  adcb %r8b, %bl                  #  3     0x8  3      OPC=adcb_r8_r8   
  retq                            #  4     0xb  1      OPC=retq         
                                                                        
.size target, .-target
