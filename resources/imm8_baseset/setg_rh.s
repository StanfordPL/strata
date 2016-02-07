  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                     #  Line  RIP  Bytes  Opcode           
.target:                   #        0    0      OPC=<label>      
  callq .read_of_into_rbx  #  1     0    5      OPC=callq_label  
  setnle %al               #  2     0x5  3      OPC=setnle_r8    
  salb $0x1, %bl           #  3     0x8  2      OPC=salb_r8_one  
  setl %ah                 #  4     0xa  3      OPC=setl_rh      
  xchgb %al, %ah           #  5     0xd  2      OPC=xchgb_rh_r8  
  retq                     #  6     0xf  1      OPC=retq         
                                                                 
.size target, .-target
