  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text              #  Line  RIP   Bytes  Opcode              
.target:            #        0     0      OPC=<label>         
  movsbw %ah, %di   #  1     0     4      OPC=movsbw_r16_rh   
  testb %dil, %bl   #  2     0x4   3      OPC=testb_r8_r8     
  cmc               #  3     0x7   1      OPC=cmc             
  movq $0x5, %r15   #  4     0x8   10     OPC=movq_r64_imm64  
  rclw $0x1, %r15w  #  5     0x12  4      OPC=rclw_r16_one    
  retq              #  6     0x16  1      OPC=retq            
                                                              
.size target, .-target
