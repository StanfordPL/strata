  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text               #  Line  RIP  Bytes  Opcode               
.target:             #        0    0      OPC=<label>          
  movsbl %ah, %ecx   #  1     0    3      OPC=movsbl_r32_rh    
  popcntw %cx, %r9w  #  2     0x3  6      OPC=popcntw_r16_r16  
  sbbb %bl, %cl      #  3     0x9  2      OPC=sbbb_r8_r8       
  xchgb %cl, %ah     #  4     0xb  2      OPC=xchgb_rh_r8      
  retq               #  5     0xd  1      OPC=retq             
                                                               
.size target, .-target
