  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                            #  Line  RIP  Bytes  Opcode            
.target:                          #        0    0      OPC=<label>       
  callq .move_016_008_bx_r8b_r9b  #  1     0    5      OPC=callq_label   
  xorq %rax, %rax                 #  2     0x5  3      OPC=xorq_r64_r64  
  adcb %r9b, %r9b                 #  3     0x8  3      OPC=adcb_r8_r8    
  adcw %bx, %bx                   #  4     0xb  3      OPC=adcw_r16_r16  
  retq                            #  5     0xe  1      OPC=retq          
                                                                         
.size target, .-target
