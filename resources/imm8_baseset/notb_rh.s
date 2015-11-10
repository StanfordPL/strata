  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text       #  Line  RIP  Bytes  Opcode        
.target:     #        0    0      OPC=<label>   
  stc        #  1     0    1      OPC=stc       
  setb %al   #  2     0x1  3      OPC=setb_r8   
  cwtl       #  3     0x4  1      OPC=cwtl      
  notl %eax  #  4     0x5  2      OPC=notl_r32  
  cltq       #  5     0x7  2      OPC=cltq      
  retq       #  6     0x9  1      OPC=retq      
                                                
.size target, .-target
