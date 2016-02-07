  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text             #  Line  RIP   Bytes  Opcode              
.target:           #        0     0      OPC=<label>         
  movq $0x1, %rax  #  1     0     10     OPC=movq_r64_imm64  
  cbtw             #  2     0xa   2      OPC=cbtw            
  cbtw             #  3     0xc   2      OPC=cbtw            
  setae %al        #  4     0xe   3      OPC=setae_r8        
  xchgb %ah, %al   #  5     0x11  2      OPC=xchgb_r8_rh     
  retq             #  6     0x13  1      OPC=retq            
                                                             
.size target, .-target
