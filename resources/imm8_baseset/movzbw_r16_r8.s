  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text               #  Line  RIP   Bytes  Opcode              
.target:             #        0     0      OPC=<label>         
  movq $0x7, %rbx    #  1     0     10     OPC=movq_r64_imm64  
  movzbl %cl, %r10d  #  2     0xa   4      OPC=movzbl_r32_r8   
  xchgw %r10w, %bx   #  3     0xe   4      OPC=xchgw_r16_r16   
  retq               #  4     0x12  1      OPC=retq            
                                                               
.size target, .-target
