  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text            #  Line  RIP  Bytes  Opcode          
.target:          #        0    0      OPC=<label>     
  sete %dil       #  1     0    4      OPC=sete_r8     
  setnge %bl      #  2     0x4  3      OPC=setnge_r8   
  addb %bl, %dil  #  3     0x7  3      OPC=addb_r8_r8  
  sete %ah        #  4     0xa  3      OPC=sete_rh     
  retq            #  5     0xd  1      OPC=retq        
                                                       
.size target, .-target
