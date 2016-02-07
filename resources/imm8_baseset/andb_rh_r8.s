  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                #  Line  RIP  Bytes  Opcode               
.target:              #        0    0      OPC=<label>          
  andb %ah, %bl       #  1     0    2      OPC=andb_r8_rh       
  movzbl %bl, %eax    #  2     0x2  3      OPC=movzbl_r32_r8    
  xchgb %al, %ah      #  3     0x5  2      OPC=xchgb_rh_r8      
  rolb $0x1, %al      #  4     0x7  2      OPC=rolb_r8_one      
  cmovnol %eax, %eax  #  5     0x9  3      OPC=cmovnol_r32_r32  
  retq                #  6     0xc  1      OPC=retq             
                                                                
.size target, .-target
