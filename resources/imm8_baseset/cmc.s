  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    2 bytes

# Text                     #  Line  RIP   Bytes  Opcode           
.target:                   #        0     0      OPC=<label>      
  setnc %r12b              #  1     0     4      OPC=setnc_r8     
  callq .read_cf_into_rcx  #  2     0x4   5      OPC=callq_label  
  xaddb %cl, %r12b         #  3     0x9   4      OPC=xaddb_r8_r8  
  callq .write_cl_to_cf    #  4     0xd   5      OPC=callq_label  
  retq                     #  5     0x12  1      OPC=retq         
                                                                  
.size target, .-target
