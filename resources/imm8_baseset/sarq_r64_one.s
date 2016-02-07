  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                            #  Line  RIP   Bytes  Opcode                 
.target:                          #        0     0      OPC=<label>            
  movq $0x1, %r13                 #  1     0     10     OPC=movq_r64_imm64     
  popcntq %r13, %rsi              #  2     0xa   5      OPC=popcntq_r64_r64    
  callq .move_016_008_bx_r8b_r9b  #  3     0xf   5      OPC=callq_label        
  callq .move_008_016_r8b_r9b_dx  #  4     0x14  5      OPC=callq_label        
  sarw $0x1, %dx                  #  5     0x19  3      OPC=sarw_r16_one       
  sarxq %rsi, %rbx, %rbx          #  6     0x1c  5      OPC=sarxq_r64_r64_r64  
  callq .set_szp_for_rbx          #  7     0x21  5      OPC=callq_label        
  retq                            #  8     0x26  1      OPC=retq               
                                                                               
.size target, .-target
