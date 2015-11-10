  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                     #  Line  RIP  Bytes  Opcode           
.target:                   #        0    0      OPC=<label>      
  callq .read_zf_into_rbx  #  1     0    5      OPC=callq_label  
  setg %ah                 #  2     0x5  3      OPC=setg_rh      
  xaddb %bl, %bh           #  3     0x8  3      OPC=xaddb_rh_r8  
  xchgb %ah, %bl           #  4     0xb  2      OPC=xchgb_r8_rh  
  retq                     #  5     0xd  1      OPC=retq         
                                                                 
.size target, .-target
