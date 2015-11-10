  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                   #  Line  RIP  Bytes  Opcode            
.target:                 #        0    0      OPC=<label>       
  xorq %rax, %rax        #  1     0    3      OPC=xorq_r64_r64  
  adcw %cx, %bx          #  2     0x3  3      OPC=adcw_r16_r16  
  callq .set_szp_for_bx  #  3     0x6  5      OPC=callq_label   
  retq                   #  4     0xb  1      OPC=retq          
                                                                
.size target, .-target
