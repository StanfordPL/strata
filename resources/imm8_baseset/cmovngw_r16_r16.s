  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                   #  Line  RIP   Bytes  Opcode              
.target:                 #        0     0      OPC=<label>         
  movzwq %cx, %r11       #  1     0     4      OPC=movzwq_r64_r16  
  setng %dl              #  2     0x4   3      OPC=setng_r8        
  callq .write_dl_to_zf  #  3     0x7   5      OPC=callq_label     
  cmovew %r11w, %bx      #  4     0xc   5      OPC=cmovew_r16_r16  
  retq                   #  5     0x11  1      OPC=retq            
                                                                   
.size target, .-target
