  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                #  Line  RIP   Bytes  Opcode              
.target:              #        0     0      OPC=<label>         
  movq $0x1, %r12     #  1     0     10     OPC=movq_r64_imm64  
  setl %ch            #  2     0xa   3      OPC=setl_rh         
  movsbw %ch, %bx     #  3     0xd   4      OPC=movsbw_r16_rh   
  movsbq %r12b, %rcx  #  4     0x11  4      OPC=movsbq_r64_r8   
  cmovzw %cx, %bx     #  5     0x15  4      OPC=cmovzw_r16_r16  
  retq                #  6     0x19  1      OPC=retq            
                                                                
.size target, .-target
