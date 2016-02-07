  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                            #  Line  RIP   Bytes  Opcode              
.target:                          #        0     0      OPC=<label>         
  movzwq %bx, %rcx                #  1     0     4      OPC=movzwq_r64_r16  
  notw %cx                        #  2     0x4   3      OPC=notw_r16        
  movq $0xffffffffffffffff, %rsi  #  3     0x7   10     OPC=movq_r64_imm64  
  addw %si, %bx                   #  4     0x11  3      OPC=addw_r16_r16    
  incw %cx                        #  5     0x14  3      OPC=incw_r16        
  movl %ecx, %ebx                 #  6     0x17  2      OPC=movl_r32_r32    
  retq                            #  7     0x19  1      OPC=retq            
                                                                            
.size target, .-target
