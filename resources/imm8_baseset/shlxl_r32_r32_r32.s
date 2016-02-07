  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                            #  Line  RIP   Bytes  Opcode                 
.target:                          #        0     0      OPC=<label>            
  movq $0xfffffffffffffffd, %r10  #  1     0     10     OPC=movq_r64_imm64     
  popcntl %r10d, %r13d            #  2     0xa   5      OPC=popcntl_r32_r32    
  cmovnzl %ecx, %r10d             #  3     0xf   4      OPC=cmovnzl_r32_r32    
  callq .read_pf_into_rbx         #  4     0x13  5      OPC=callq_label        
  andl %r13d, %edx                #  5     0x18  3      OPC=andl_r32_r32       
  testl %r13d, %r13d              #  6     0x1b  3      OPC=testl_r32_r32      
  shlxq %rdx, %r10, %rdi          #  7     0x1e  5      OPC=shlxq_r64_r64_r64  
  cmovgel %edi, %ebx              #  8     0x23  3      OPC=cmovgel_r32_r32    
  retq                            #  9     0x26  1      OPC=retq               
                                                                               
.size target, .-target
