  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text            #  Line  RIP  Bytes  Opcode            
.target:          #        0    0      OPC=<label>       
  movb %ah, %al   #  1     0    2      OPC=movb_r8_rh    
  salw $0x1, %ax  #  2     0x2  3      OPC=salw_r16_one  
  retq            #  3     0x5  1      OPC=retq          
                                                         
.size target, .-target
