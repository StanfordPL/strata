  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                               #  Line  RIP   Bytes  Opcode              
.target:                             #        0     0      OPC=<label>         
  movsbq %bl, %rbx                   #  1     0     4      OPC=movsbq_r64_r8   
  movb %ah, %al                      #  2     0x4   2      OPC=movb_r8_rh      
  callq .move_064_032_rbx_r12d_r13d  #  3     0x6   5      OPC=callq_label     
  xorq %r13, %r13                    #  4     0xb   3      OPC=xorq_r64_r64    
  movb %bl, %ah                      #  5     0xe   2      OPC=movb_rh_r8      
  adcb %al, %r12b                    #  6     0x10  3      OPC=adcb_r8_r8      
  callq .move_008_016_r12b_r13b_bx   #  7     0x13  5      OPC=callq_label     
  movswq %bx, %rbx                   #  8     0x18  4      OPC=movswq_r64_r16  
  retq                               #  9     0x1c  1      OPC=retq            
                                                                               
.size target, .-target
