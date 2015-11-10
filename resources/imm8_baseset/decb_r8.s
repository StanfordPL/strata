  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                            #  Line  RIP   Bytes  Opcode              
.target:                          #        0     0      OPC=<label>         
  movq $0xffffffffffffffff, %rdi  #  1     0     10     OPC=movq_r64_imm64  
  xaddb %dil, %bl                 #  2     0xa   4      OPC=xaddb_r8_r8     
  movsbq %bl, %r11                #  3     0xe   4      OPC=movsbq_r64_r8   
  movswq %r11w, %r10              #  4     0x12  4      OPC=movswq_r64_r16  
  incb %r10b                      #  5     0x16  3      OPC=incb_r8         
  callq .set_szp_for_bl           #  6     0x19  5      OPC=callq_label     
  retq                            #  7     0x1e  1      OPC=retq            
                                                                            
.size target, .-target
