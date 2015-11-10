  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text              #  Line  RIP  Bytes  Opcode             
.target:            #        0    0      OPC=<label>        
  movsbl %bl, %ecx  #  1     0    3      OPC=movsbl_r32_r8  
  xorl %eax, %eax   #  2     0x3  2      OPC=xorl_r32_r32   
  xaddb %ch, %ah    #  3     0x5  3      OPC=xaddb_rh_rh    
  shrl $0x1, %ecx   #  4     0x8  2      OPC=shrl_r32_one   
  movsbw %cl, %bx   #  5     0xa  4      OPC=movsbw_r16_r8  
  retq              #  6     0xe  1      OPC=retq           
                                                            
.size target, .-target
