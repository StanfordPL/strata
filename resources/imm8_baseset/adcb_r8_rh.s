  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                              #  Line  RIP  Bytes  Opcode              
.target:                            #        0    0      OPC=<label>         
  movsbl %ah, %esi                  #  1     0    3      OPC=movsbl_r32_rh   
  movzwq %si, %rcx                  #  2     0x3  4      OPC=movzwq_r64_r16  
  callq .move_016_008_cx_r12b_r13b  #  3     0x7  5      OPC=callq_label     
  adcb %r12b, %bl                   #  4     0xc  3      OPC=adcb_r8_r8      
  retq                              #  5     0xf  1      OPC=retq            
                                                                             
.size target, .-target
