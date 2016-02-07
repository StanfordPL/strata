  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                    #  Line  RIP   Bytes  Opcode              
.target:                  #        0     0      OPC=<label>         
  movq $0x20, %rcx        #  1     0     10     OPC=movq_r64_imm64  
  salq $0x1, %rcx         #  2     0xa   3      OPC=salq_r64_one    
  movswq %bx, %rdi        #  3     0xd   4      OPC=movswq_r64_r16  
  setne %cl               #  4     0x11  3      OPC=setne_r8        
  sarq %cl, %rdi          #  5     0x14  3      OPC=sarq_r64_cl     
  movslq %edi, %rbx       #  6     0x17  3      OPC=movslq_r64_r32  
  incl %ecx               #  7     0x1a  2      OPC=incl_r32        
  callq .set_szp_for_ebx  #  8     0x1c  5      OPC=callq_label     
  retq                    #  9     0x21  1      OPC=retq            
                                                                    
.size target, .-target
