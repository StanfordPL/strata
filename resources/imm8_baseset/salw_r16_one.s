  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                   #  Line  RIP  Bytes  Opcode               
.target:                 #        0    0      OPC=<label>          
  popcntw %bx, %r15w     #  1     0    6      OPC=popcntw_r16_r16  
  rclw $0x1, %bx         #  2     0x6  3      OPC=rclw_r16_one     
  callq .set_szp_for_bx  #  3     0x9  5      OPC=callq_label      
  retq                   #  4     0xe  1      OPC=retq             
                                                                   
.size target, .-target
