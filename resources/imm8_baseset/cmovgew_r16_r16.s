  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text              #  Line  RIP   Bytes  Opcode               
.target:            #        0     0      OPC=<label>          
  setge %dh         #  1     0     3      OPC=setge_rh         
  movzbw %dh, %ax   #  2     0x3   4      OPC=movzbw_r16_rh    
  movswl %ax, %edx  #  3     0x7   3      OPC=movswl_r32_r16   
  orw %dx, %ax      #  4     0xa   3      OPC=orw_r16_r16      
  cmovnew %cx, %bx  #  5     0xd   4      OPC=cmovnew_r16_r16  
  retq              #  6     0x11  1      OPC=retq             
                                                               
.size target, .-target
