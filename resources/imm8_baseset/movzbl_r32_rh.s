  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                     #  Line  RIP  Bytes  Opcode           
.target:                   #        0    0      OPC=<label>      
  callq .clear_zf          #  1     0    5      OPC=callq_label  
  callq .read_zf_into_rbx  #  2     0x5  5      OPC=callq_label  
  movb %ah, %bl            #  3     0xa  2      OPC=movb_r8_rh   
  retq                     #  4     0xc  1      OPC=retq         
                                                                 
.size target, .-target
