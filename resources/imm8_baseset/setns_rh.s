  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text           #  Line  RIP  Bytes  Opcode          
.target:         #        0    0      OPC=<label>     
  setns %cl      #  1     0    3      OPC=setns_r8    
  movb %cl, %ah  #  2     0x3  2      OPC=movb_rh_r8  
  retq           #  3     0x5  1      OPC=retq        
                                                      
.size target, .-target
