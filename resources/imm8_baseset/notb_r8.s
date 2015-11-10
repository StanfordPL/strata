  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                            #  Line  RIP   Bytes  Opcode              
.target:                          #        0     0      OPC=<label>         
  movsbq %bl, %rsi                #  1     0     4      OPC=movsbq_r64_r8   
  movq $0xffffffffffffffff, %r10  #  2     0x4   10     OPC=movq_r64_imm64  
  xorq %r10, %rsi                 #  3     0xe   3      OPC=xorq_r64_r64    
  xaddb %r10b, %sil               #  4     0x11  4      OPC=xaddb_r8_r8     
  movsbl %r10b, %ebx              #  5     0x15  4      OPC=movsbl_r32_r8   
  retq                            #  6     0x19  1      OPC=retq            
                                                                            
.size target, .-target
