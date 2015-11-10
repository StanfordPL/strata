  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                     #  Line  RIP   Bytes  Opcode           
.target:                   #        0     0      OPC=<label>      
  callq .set_szp_for_bl    #  1     0     5      OPC=callq_label  
  callq .read_sf_into_rcx  #  2     0x5   5      OPC=callq_label  
  callq .write_cl_to_cf    #  3     0xa   5      OPC=callq_label  
  adcb %bl, %bl            #  4     0xf   2      OPC=adcb_r8_r8   
  retq                     #  5     0x11  1      OPC=retq         
                                                                  
.size target, .-target
