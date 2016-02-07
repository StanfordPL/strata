  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text              #  Line  RIP   Bytes  Opcode               
.target:            #        0     0      OPC=<label>          
  movzwq %cx, %rdi  #  1     0     4      OPC=movzwq_r64_r16   
  callq .set_cf     #  2     0x4   5      OPC=callq_label      
  cmovlew %bx, %cx  #  3     0x9   4      OPC=cmovlew_r16_r16  
  incw %di          #  4     0xd   3      OPC=incw_r16         
  cmovbew %cx, %bx  #  5     0x10  4      OPC=cmovbew_r16_r16  
  retq              #  6     0x14  1      OPC=retq             
                                                               
.size target, .-target
