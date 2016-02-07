  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text            #  Line  RIP  Bytes  Opcode           
.target:          #        0    0      OPC=<label>      
  movb %cl, %dh   #  1     0    2      OPC=movb_rh_r8   
  andb %bl, %dh   #  2     0x2  2      OPC=andb_rh_r8   
  xchgb %dh, %bl  #  3     0x4  2      OPC=xchgb_r8_rh  
  retq            #  4     0x6  1      OPC=retq         
                                                        
.size target, .-target
