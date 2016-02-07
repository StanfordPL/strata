  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                               #  Line  RIP   Bytes  Opcode              
.target:                             #        0     0      OPC=<label>         
  movq $0xfffffffffffffff0, %rbx     #  1     0     10     OPC=movq_r64_imm64  
  salw $0x1, %bx                     #  2     0xa   3      OPC=salw_r16_one    
  callq .move_064_032_rbx_r10d_r11d  #  3     0xd   5      OPC=callq_label     
  movswq %r11w, %r10                 #  4     0x12  4      OPC=movswq_r64_r16  
  callq .move_016_032_r10w_r11w_edx  #  5     0x16  5      OPC=callq_label     
  xaddb %ah, %dl                     #  6     0x1b  3      OPC=xaddb_r8_rh     
  xchgb %ah, %dl                     #  7     0x1e  2      OPC=xchgb_r8_rh     
  retq                               #  8     0x20  1      OPC=retq            
                                                                               
.size target, .-target
