  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text              #  Line  RIP   Bytes  Opcode             
.target:            #        0     0      OPC=<label>        
  movsbl %cl, %eax  #  1     0     3      OPC=movsbl_r32_r8  
  movsbl %bl, %esi  #  2     0x3   3      OPC=movsbl_r32_r8  
  xorl %esi, %eax   #  3     0x6   2      OPC=xorl_r32_r32   
  callq .clear_of   #  4     0x8   5      OPC=callq_label    
  xchgw %ax, %si    #  5     0xd   3      OPC=xchgw_r16_r16  
  xchgb %sil, %bl   #  6     0x10  3      OPC=xchgb_r8_r8    
  retq              #  7     0x13  1      OPC=retq           
                                                             
.size target, .-target
