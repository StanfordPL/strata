  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                               #  Line  RIP   Bytes  Opcode              
.target:                             #        0     0      OPC=<label>         
  movzbq %bl, %rdx                   #  1     0     4      OPC=movzbq_r64_r8   
  callq .move_064_032_rdx_r10d_r11d  #  2     0x4   5      OPC=callq_label     
  xchgb %al, %dl                     #  3     0x9   2      OPC=xchgb_r8_r8     
  callq .move_008_016_r10b_r11b_bx   #  4     0xb   5      OPC=callq_label     
  setnbe %ch                         #  5     0x10  3      OPC=setnbe_rh       
  subb %bl, %dl                      #  6     0x13  2      OPC=subb_r8_r8      
  cmovew %cx, %bx                    #  7     0x15  4      OPC=cmovew_r16_r16  
  retq                               #  8     0x19  1      OPC=retq            
                                                                               
.size target, .-target
