  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    2 bytes

# Text                            #  Line  RIP   Bytes  Opcode              
.target:                          #        0     0      OPC=<label>         
  movq $0xfffffffffffffff8, %rax  #  1     0     10     OPC=movq_r64_imm64  
  salb $0x1, %ah                  #  2     0xa   2      OPC=salb_rh_one     
  cwtd                            #  3     0xc   2      OPC=cwtd            
  rclw $0x1, %dx                  #  4     0xe   3      OPC=rclw_r16_one    
  retq                            #  5     0x11  1      OPC=retq            
                                                                            
.size target, .-target
