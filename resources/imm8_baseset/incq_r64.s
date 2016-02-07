  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                     #  Line  RIP   Bytes  Opcode            
.target:                   #        0     0      OPC=<label>       
  xorq %rax, %rax          #  1     0     3      OPC=xorq_r64_r64  
  callq .read_cf_into_rcx  #  2     0x3   5      OPC=callq_label   
  setna %cl                #  3     0x8   3      OPC=setna_r8      
  adcq %rbx, %rcx          #  4     0xb   3      OPC=adcq_r64_r64  
  movq %rcx, %rbx          #  5     0xe   3      OPC=movq_r64_r64  
  retq                     #  6     0x11  1      OPC=retq          
                                                                   
.size target, .-target
