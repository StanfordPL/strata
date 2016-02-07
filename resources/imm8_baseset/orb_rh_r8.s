  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text               #  Line  RIP  Bytes  Opcode             
.target:             #        0    0      OPC=<label>        
  orb %ah, %bl       #  1     0    2      OPC=orb_r8_rh      
  setng %r9b         #  2     0x2  4      OPC=setng_r8       
  movzbl %r9b, %ecx  #  3     0x6  4      OPC=movzbl_r32_r8  
  xorb %bl, %ch      #  4     0xa  2      OPC=xorb_rh_r8     
  xchgb %ah, %bl     #  5     0xc  2      OPC=xchgb_r8_rh    
  retq               #  6     0xe  1      OPC=retq           
                                                             
.size target, .-target
