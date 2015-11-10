  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP   Bytes  Opcode           
.target:                            #        0     0      OPC=<label>      
  callq .read_cf_into_rbx           #  1     0     5      OPC=callq_label  
  callq .read_cf_into_rcx           #  2     0x5   5      OPC=callq_label  
  callq .move_016_008_bx_r10b_r11b  #  3     0xa   5      OPC=callq_label  
  callq .move_008_016_r10b_r11b_bx  #  4     0xf   5      OPC=callq_label  
  setnc %cl                         #  5     0x14  3      OPC=setnc_r8     
  callq .move_016_008_cx_r8b_r9b    #  6     0x17  5      OPC=callq_label  
  xaddb %bl, %r8b                   #  7     0x1c  4      OPC=xaddb_r8_r8  
  retq                              #  8     0x20  1      OPC=retq         
                                                                           
.size target, .-target
