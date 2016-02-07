  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                            #  Line  RIP  Bytes  Opcode              
.target:                          #        0    0      OPC=<label>         
  adcb %ah, %bl                   #  1     0    2      OPC=adcb_r8_rh      
  movq $0xffffffffffffffc0, %rax  #  2     0x2  10     OPC=movq_r64_imm64  
  xchgb %ah, %bl                  #  3     0xc  2      OPC=xchgb_r8_rh     
  retq                            #  4     0xe  1      OPC=retq            
                                                                           
.size target, .-target
