  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text            #  Line  RIP  Bytes  Opcode           
.target:          #        0    0      OPC=<label>      
  xchgb %bl, %cl  #  1     0    2      OPC=xchgb_r8_r8  
  addb %cl, %bl   #  2     0x2  2      OPC=addb_r8_r8   
  retq            #  3     0x4  1      OPC=retq         
                                                        
.size target, .-target
