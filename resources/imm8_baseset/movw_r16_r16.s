  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP  Bytes  Opcode           
.target:                            #        0    0      OPC=<label>      
  callq .move_016_008_cx_r10b_r11b  #  1     0    5      OPC=callq_label  
  xchgb %cl, %r10b                  #  2     0x5  3      OPC=xchgb_r8_r8  
  callq .move_008_016_r10b_r11b_bx  #  3     0x8  5      OPC=callq_label  
  retq                              #  4     0xd  1      OPC=retq         
                                                                          
.size target, .-target
