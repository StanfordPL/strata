  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                            #  Line  RIP   Bytes  Opcode               
.target:                          #        0     0      OPC=<label>          
  movq $0xfffffffffffffff9, %rbx  #  1     0     10     OPC=movq_r64_imm64   
  movl %ebx, %ebx                 #  2     0xa   2      OPC=movl_r32_r32     
  popcntl %ebx, %ebx              #  3     0xc   4      OPC=popcntl_r32_r32  
  adcw %bx, %bx                   #  4     0x10  3      OPC=adcw_r16_r16     
  movb %bh, %bh                   #  5     0x13  2      OPC=movb_rh_rh       
  xchgb %bl, %cl                  #  6     0x15  2      OPC=xchgb_r8_r8      
  retq                            #  7     0x17  1      OPC=retq             
                                                                             
.size target, .-target
