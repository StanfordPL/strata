  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP   Bytes  Opcode              
.target:                            #        0     0      OPC=<label>         
  callq .move_016_008_bx_r10b_r11b  #  1     0     5      OPC=callq_label     
  movq $0x80, %rdi                  #  2     0x5   10     OPC=movq_r64_imm64  
  addb %r11b, %dil                  #  3     0xf   3      OPC=addb_r8_r8      
  adcw %bx, %bx                     #  4     0x12  3      OPC=adcw_r16_r16    
  retq                              #  5     0x15  1      OPC=retq            
                                                                              
.size target, .-target
