  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                   #  Line  RIP  Bytes  Opcode               
.target:                 #        0    0      OPC=<label>          
  movsbl %bl, %ecx       #  1     0    3      OPC=movsbl_r32_r8    
  popcntl %ecx, %r14d    #  2     0x3  5      OPC=popcntl_r32_r32  
  rclb $0x1, %bl         #  3     0x8  2      OPC=rclb_r8_one      
  callq .set_szp_for_bl  #  4     0xa  5      OPC=callq_label      
  retq                   #  5     0xf  1      OPC=retq             
                                                                   
.size target, .-target
