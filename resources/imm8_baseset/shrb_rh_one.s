  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text               #  Line  RIP  Bytes  Opcode             
.target:             #        0    0      OPC=<label>        
  movzbl %ah, %edi   #  1     0    3      OPC=movzbl_r32_rh  
  movsbl %dil, %eax  #  2     0x3  4      OPC=movsbl_r32_r8  
  xchgw %ax, %di     #  3     0x7  3      OPC=xchgw_r16_r16  
  shrl $0x1, %eax    #  4     0xa  2      OPC=shrl_r32_one   
  xchgb %ah, %al     #  5     0xc  2      OPC=xchgb_r8_rh    
  retq               #  6     0xe  1      OPC=retq           
                                                             
.size target, .-target
