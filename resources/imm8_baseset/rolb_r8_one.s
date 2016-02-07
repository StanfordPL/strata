  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text               #  Line  RIP  Bytes  Opcode              
.target:             #        0    0      OPC=<label>         
  movsbl %bl, %r15d  #  1     0    4      OPC=movsbl_r32_r8   
  movswq %r15w, %r8  #  2     0x4  4      OPC=movswq_r64_r16  
  addb %r8b, %r15b   #  3     0x8  3      OPC=addb_r8_r8      
  rclb $0x1, %bl     #  4     0xb  2      OPC=rclb_r8_one     
  retq               #  5     0xd  1      OPC=retq            
                                                              
.size target, .-target
