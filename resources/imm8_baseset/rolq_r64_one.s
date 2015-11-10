  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                               #  Line  RIP   Bytes  Opcode            
.target:                             #        0     0      OPC=<label>       
  callq .move_064_032_rbx_r10d_r11d  #  1     0     5      OPC=callq_label   
  callq .move_032_064_r10d_r11d_rdx  #  2     0x5   5      OPC=callq_label   
  addq %rdx, %rdx                    #  3     0xa   3      OPC=addq_r64_r64  
  rclq $0x1, %rbx                    #  4     0xd   3      OPC=rclq_r64_one  
  retq                               #  5     0x10  1      OPC=retq          
                                                                             
.size target, .-target
