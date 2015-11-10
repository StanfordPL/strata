  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP   Bytes  Opcode           
.target:                            #        0     0      OPC=<label>      
  callq .read_zf_into_rcx           #  1     0     5      OPC=callq_label  
  callq .read_cf_into_rbx           #  2     0x5   5      OPC=callq_label  
  callq .move_064_032_rcx_r8d_r9d   #  3     0xa   5      OPC=callq_label  
  callq .move_r8b_to_byte_2_of_rbx  #  4     0xf   5      OPC=callq_label  
  callq .set_szp_for_ebx            #  5     0x14  5      OPC=callq_label  
  sete %ah                          #  6     0x19  3      OPC=sete_rh      
  retq                              #  7     0x1c  1      OPC=retq         
                                                                           
.size target, .-target
