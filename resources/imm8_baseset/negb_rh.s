  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text              #  Line  RIP  Bytes  Opcode             
.target:            #        0    0      OPC=<label>        
  movsbl %ah, %ebx  #  1     0    3      OPC=movsbl_r32_rh  
  movw %bx, %ax     #  2     0x3  3      OPC=movw_r16_r16   
  negb %bl          #  3     0x6  2      OPC=negb_r8        
  xchgb %ah, %bl    #  4     0x8  2      OPC=xchgb_r8_rh    
  retq              #  5     0xa  1      OPC=retq           
                                                            
.size target, .-target
