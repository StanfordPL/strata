  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text               #  Line  RIP  Bytes  Opcode              
.target:             #        0    0      OPC=<label>         
  movzbw %cl, %dx    #  1     0    4      OPC=movzbw_r16_r8   
  adcb %dh, %dh      #  2     0x4  2      OPC=adcb_rh_rh      
  cmovel %ecx, %ebx  #  3     0x6  3      OPC=cmovel_r32_r32  
  retq               #  4     0x9  1      OPC=retq            
                                                              
.size target, .-target
