  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                            #  Line  RIP   Bytes  Opcode              
.target:                          #        0     0      OPC=<label>         
  movq $0xffffffffffffffff, %r11  #  1     0     10     OPC=movq_r64_imm64  
  addq %r11, %rbx                 #  2     0xa   3      OPC=addq_r64_r64    
  notq %rbx                       #  3     0xd   3      OPC=notq_r64        
  callq .set_szp_for_rbx          #  4     0x10  5      OPC=callq_label     
  retq                            #  5     0x15  1      OPC=retq            
                                                                            
.size target, .-target
