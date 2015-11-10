  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text             #  Line  RIP  Bytes  Opcode              
.target:           #        0    0      OPC=<label>         
  setng %ah        #  1     0    3      OPC=setng_rh        
  movq $0x4, %rbx  #  2     0x3  10     OPC=movq_r64_imm64  
  xchgb %ah, %bl   #  3     0xd  2      OPC=xchgb_r8_rh     
  retq             #  4     0xf  1      OPC=retq            
                                                            
.size target, .-target
