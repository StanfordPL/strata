  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                            #  Line  RIP   Bytes  Opcode              
.target:                          #        0     0      OPC=<label>         
  movzwq %bx, %rax                #  1     0     4      OPC=movzwq_r64_r16  
  xaddw %bx, %bx                  #  2     0x4   4      OPC=xaddw_r16_r16   
  movq $0xffffffffffffffff, %r10  #  3     0x8   10     OPC=movq_r64_imm64  
  xorq %rax, %r10                 #  4     0x12  3      OPC=xorq_r64_r64    
  xaddw %bx, %r10w                #  5     0x15  5      OPC=xaddw_r16_r16   
  retq                            #  6     0x1a  1      OPC=retq            
                                                                            
.size target, .-target
