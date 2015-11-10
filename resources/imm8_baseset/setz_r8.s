  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                     #  Line  RIP   Bytes  Opcode              
.target:                   #        0     0      OPC=<label>         
  movq $0x6, %rbx          #  1     0     10     OPC=movq_r64_imm64  
  rolw $0x1, %bx           #  2     0xa   3      OPC=rolw_r16_one    
  movb %bl, %bl            #  3     0xd   2      OPC=movb_r8_r8      
  callq .read_zf_into_rcx  #  4     0xf   5      OPC=callq_label     
  xchgb %cl, %bl           #  5     0x14  2      OPC=xchgb_r8_r8     
  retq                     #  6     0x16  1      OPC=retq            
                                                                     
.size target, .-target
