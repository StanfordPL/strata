  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                               #  Line  RIP   Bytes  Opcode             
.target:                             #        0     0      OPC=<label>        
  movb %ah, %cl                      #  1     0     2      OPC=movb_r8_rh     
  movb %bl, %ah                      #  2     0x2   2      OPC=movb_rh_r8     
  movsbq %cl, %rdx                   #  3     0x4   4      OPC=movsbq_r64_r8  
  callq .move_064_032_rdx_r10d_r11d  #  4     0x8   5      OPC=callq_label    
  callq .move_032_064_r10d_r11d_rbx  #  5     0xd   5      OPC=callq_label    
  retq                               #  6     0x12  1      OPC=retq           
                                                                              
.size target, .-target
