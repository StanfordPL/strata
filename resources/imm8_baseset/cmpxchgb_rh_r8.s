  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text             #  Line  RIP  Bytes  Opcode              
.target:           #        0    0      OPC=<label>         
  movb %bh, %dh    #  1     0    2      OPC=movb_rh_rh      
  movb %cl, %ch    #  2     0x2  2      OPC=movb_rh_r8      
  subb %dh, %al    #  3     0x4  2      OPC=subb_r8_rh      
  cmovzw %cx, %bx  #  4     0x6  4      OPC=cmovzw_r16_r16  
  xchgb %al, %dh   #  5     0xa  2      OPC=xchgb_rh_r8     
  retq             #  6     0xc  1      OPC=retq            
                                                            
.size target, .-target
