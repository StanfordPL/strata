  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                            #  Line  RIP   Bytes  Opcode              
.target:                          #        0     0      OPC=<label>         
  callq .read_cf_into_rcx         #  1     0     5      OPC=callq_label     
  movq $0xffffffffffffff80, %rax  #  2     0x5   10     OPC=movq_r64_imm64  
  xchgb %cl, %ah                  #  3     0xf   2      OPC=xchgb_rh_r8     
  retq                            #  4     0x11  1      OPC=retq            
                                                                            
.size target, .-target
