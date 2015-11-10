  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                     #  Line  RIP  Bytes  Opcode            
.target:                   #        0    0      OPC=<label>       
  xorq %rax, %rax          #  1     0    3      OPC=xorq_r64_r64  
  movb %bl, %ah            #  2     0x3  2      OPC=movb_rh_r8    
  callq .read_pf_into_rbx  #  3     0x5  5      OPC=callq_label   
  shlb $0x1, %ah           #  4     0xa  2      OPC=shlb_rh_one   
  xchgb %bl, %ah           #  5     0xc  2      OPC=xchgb_rh_r8   
  retq                     #  6     0xe  1      OPC=retq          
                                                                  
.size target, .-target
