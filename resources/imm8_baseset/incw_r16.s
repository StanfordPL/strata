  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                            #  Line  RIP   Bytes  Opcode              
.target:                          #        0     0      OPC=<label>         
  xorq %rax, %rax                 #  1     0     3      OPC=xorq_r64_r64    
  movq $0xfffffffffffffffd, %rcx  #  2     0x3   10     OPC=movq_r64_imm64  
  setae %r14b                     #  3     0xd   4      OPC=setae_r8        
  xorq %rax, %rcx                 #  4     0x11  3      OPC=xorq_r64_r64    
  movsbq %r14b, %r14              #  5     0x14  4      OPC=movsbq_r64_r8   
  adcw %r14w, %bx                 #  6     0x18  4      OPC=adcw_r16_r16    
  callq .set_szp_for_bx           #  7     0x1c  5      OPC=callq_label     
  retq                            #  8     0x21  1      OPC=retq            
                                                                            
.size target, .-target
