  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                               #  Line  RIP   Bytes  Opcode              
.target:                             #        0     0      OPC=<label>         
  movq $0x2, %rbx                    #  1     0     10     OPC=movq_r64_imm64  
  callq .move_032_016_ebx_r10w_r11w  #  2     0xa   5      OPC=callq_label     
  callq .move_008_016_r10b_r11b_bx   #  3     0xf   5      OPC=callq_label     
  setae %bl                          #  4     0x14  3      OPC=setae_r8        
  xchgw %bx, %bx                     #  5     0x17  3      OPC=xchgw_r16_r16   
  retq                               #  6     0x1a  1      OPC=retq            
                                                                               
.size target, .-target
