  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                   #  Line  RIP  Bytes  Opcode               
.target:                 #        0    0      OPC=<label>          
  setl %dl               #  1     0    3      OPC=setl_r8          
  callq .write_dl_to_cf  #  2     0x3  5      OPC=callq_label      
  cmovbew %cx, %bx       #  3     0x8  4      OPC=cmovbew_r16_r16  
  retq                   #  4     0xc  1      OPC=retq             
                                                                   
.size target, .-target
