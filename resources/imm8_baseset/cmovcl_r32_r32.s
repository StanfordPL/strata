  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                   #  Line  RIP  Bytes  Opcode               
.target:                 #        0    0      OPC=<label>          
  setnc %dl              #  1     0    3      OPC=setnc_r8         
  callq .write_dl_to_zf  #  2     0x3  5      OPC=callq_label      
  cmovnel %ecx, %ebx     #  3     0x8  3      OPC=cmovnel_r32_r32  
  retq                   #  4     0xb  1      OPC=retq             
                                                                   
.size target, .-target
