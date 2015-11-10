  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text             #  Line  RIP  Bytes  Opcode           
.target:           #        0    0      OPC=<label>      
  callq .clear_pf  #  1     0    5      OPC=callq_label  
  setp %bh         #  2     0x5  3      OPC=setp_rh      
  xchgb %bh, %bl   #  3     0x8  2      OPC=xchgb_r8_rh  
  subb %bh, %ah    #  4     0xa  2      OPC=subb_rh_rh   
  retq             #  5     0xc  1      OPC=retq         
                                                         
.size target, .-target
