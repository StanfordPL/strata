  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP   Bytes  Opcode              
.target:                            #        0     0      OPC=<label>         
  callq .move_016_008_cx_r10b_r11b  #  1     0     5      OPC=callq_label     
  movw %bx, %r12w                   #  2     0x5   4      OPC=movw_r16_r16    
  movzwq %r12w, %rcx                #  3     0x9   4      OPC=movzwq_r64_r16  
  callq .move_008_016_r10b_r11b_bx  #  4     0xd   5      OPC=callq_label     
  retq                              #  5     0x12  1      OPC=retq            
                                                                              
.size target, .-target
