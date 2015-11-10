  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                            #  Line  RIP   Bytes  Opcode              
.target:                          #        0     0      OPC=<label>         
  movq $0xfffffffffffffffb, %rbx  #  1     0     10     OPC=movq_r64_imm64  
  movb %ah, %bl                   #  2     0xa   2      OPC=movb_r8_rh      
  movslq %ebx, %r10               #  3     0xc   3      OPC=movslq_r64_r32  
  movsbq %r10b, %rbx              #  4     0xf   4      OPC=movsbq_r64_r8   
  retq                            #  5     0x13  1      OPC=retq            
                                                                            
.size target, .-target
