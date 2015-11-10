  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text            #  Line  RIP  Bytes  Opcode           
.target:          #        0    0      OPC=<label>      
  xorb %al, %al   #  1     0    2      OPC=xorb_r8_r8   
  xchgb %al, %ah  #  2     0x2  2      OPC=xchgb_rh_r8  
  subb %bh, %al   #  3     0x4  2      OPC=subb_r8_rh   
  xchgb %al, %ah  #  4     0x6  2      OPC=xchgb_rh_r8  
  retq            #  5     0x8  1      OPC=retq         
                                                        
.size target, .-target
