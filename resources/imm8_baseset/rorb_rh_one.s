  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text              #  Line  RIP  Bytes  Opcode             
.target:            #        0    0      OPC=<label>        
  movzbl %ah, %ebx  #  1     0    3      OPC=movzbl_r32_rh  
  rorb $0x1, %bl    #  2     0x3  2      OPC=rorb_r8_one    
  movb %bl, %ah     #  3     0x5  2      OPC=movb_rh_r8     
  xaddb %bl, %bl    #  4     0x7  3      OPC=xaddb_r8_r8    
  retq              #  5     0xa  1      OPC=retq           
                                                            
.size target, .-target
