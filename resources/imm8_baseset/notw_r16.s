  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                            #  Line  RIP   Bytes  Opcode              
.target:                          #        0     0      OPC=<label>         
  movq $0xfffffffffffffffa, %rax  #  1     0     10     OPC=movq_r64_imm64  
  movsbl %ah, %ebp                #  2     0xa   3      OPC=movsbl_r32_rh   
  xorw %bp, %bx                   #  3     0xd   3      OPC=xorw_r16_r16    
  retq                            #  4     0x10  1      OPC=retq            
                                                                            
.size target, .-target
