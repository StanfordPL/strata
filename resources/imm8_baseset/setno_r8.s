  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                     #  Line  RIP   Bytes  Opcode           
.target:                   #        0     0      OPC=<label>      
  callq .set_cf            #  1     0     5      OPC=callq_label  
  callq .read_cf_into_rbx  #  2     0x5   5      OPC=callq_label  
  setno %bh                #  3     0xa   3      OPC=setno_rh     
  xaddb %bl, %bh           #  4     0xd   3      OPC=xaddb_rh_r8  
  retq                     #  5     0x10  1      OPC=retq         
                                                                  
.size target, .-target
