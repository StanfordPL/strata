  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text             #  Line  RIP  Bytes  Opcode              
.target:           #        0    0      OPC=<label>         
  setne %dh        #  1     0    3      OPC=setne_rh        
  movq $0x0, %rbx  #  2     0x3  10     OPC=movq_r64_imm64  
  xchgb %dh, %bl   #  3     0xd  2      OPC=xchgb_r8_rh     
  retq             #  4     0xf  1      OPC=retq            
                                                            
.size target, .-target
