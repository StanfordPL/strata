  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text              #  Line  RIP  Bytes  Opcode             
.target:            #        0    0      OPC=<label>        
  xorq %rax, %rax   #  1     0    3      OPC=xorq_r64_r64   
  xchgb %al, %bl    #  2     0x3  2      OPC=xchgb_r8_r8    
  movsbl %ah, %ebx  #  3     0x5  3      OPC=movsbl_r32_rh  
  sbbb %cl, %al     #  4     0x8  2      OPC=sbbb_r8_r8     
  xchgw %bx, %ax    #  5     0xa  2      OPC=xchgw_ax_r16   
  retq              #  6     0xc  1      OPC=retq           
                                                            
.size target, .-target
