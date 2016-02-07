  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                   #  Line  RIP  Bytes  Opcode              
.target:                 #        0    0      OPC=<label>         
  movsbl %ah, %ebp       #  1     0    3      OPC=movsbl_r32_rh   
  movswl %bp, %r14d      #  2     0x3  4      OPC=movswl_r32_r16  
  adcb %r14b, %bl        #  3     0x7  3      OPC=adcb_r8_r8      
  callq .set_szp_for_bl  #  4     0xa  5      OPC=callq_label     
  retq                   #  5     0xf  1      OPC=retq            
                                                                  
.size target, .-target
