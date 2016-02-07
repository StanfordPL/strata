  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                     #  Line  RIP  Bytes  Opcode             
.target:                   #        0    0      OPC=<label>        
  movsbl %ah, %eax         #  1     0    3      OPC=movsbl_r32_rh  
  orb %bl, %al             #  2     0x3  2      OPC=orb_r8_r8      
  movl %eax, %ebp          #  3     0x5  2      OPC=movl_r32_r32   
  callq .read_cf_into_rbx  #  4     0x7  5      OPC=callq_label    
  xchgw %bp, %bx           #  5     0xc  3      OPC=xchgw_r16_r16  
  retq                     #  6     0xf  1      OPC=retq           
                                                                   
.size target, .-target
