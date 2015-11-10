  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text              #  Line  RIP   Bytes  Opcode              
.target:            #        0     0      OPC=<label>         
  movsbl %ah, %edx  #  1     0     3      OPC=movsbl_r32_rh   
  andb %dl, %bl     #  2     0x3   2      OPC=andb_r8_r8      
  movq $0x6, %rax   #  3     0x5   10     OPC=movq_r64_imm64  
  xchgb %ah, %bl    #  4     0xf   2      OPC=xchgb_r8_rh     
  retq              #  5     0x11  1      OPC=retq            
                                                              
.size target, .-target
