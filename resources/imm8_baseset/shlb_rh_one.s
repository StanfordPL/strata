  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                            #  Line  RIP   Bytes  Opcode             
.target:                          #        0     0      OPC=<label>        
  movzbw %ah, %dx                 #  1     0     4      OPC=movzbw_r16_rh  
  callq .move_016_008_dx_r8b_r9b  #  2     0x4   5      OPC=callq_label    
  xaddb %r8b, %r8b                #  3     0x9   4      OPC=xaddb_r8_r8    
  callq .move_008_016_r8b_r9b_cx  #  4     0xd   5      OPC=callq_label    
  movb %cl, %ah                   #  5     0x12  2      OPC=movb_rh_r8     
  retq                            #  6     0x14  1      OPC=retq           
                                                                           
.size target, .-target
