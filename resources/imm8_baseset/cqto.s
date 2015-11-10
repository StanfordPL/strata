  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                            #  Line  RIP   Bytes  Opcode              
.target:                          #        0     0      OPC=<label>         
  shlq $0x1, %rax                 #  1     0     3      OPC=shlq_r64_one    
  movq $0xfffffffffffffffd, %rdx  #  2     0x3   10     OPC=movq_r64_imm64  
  sbbq %rdx, %rdx                 #  3     0xd   3      OPC=sbbq_r64_r64    
  retq                            #  4     0x10  1      OPC=retq            
                                                                            
.size target, .-target
