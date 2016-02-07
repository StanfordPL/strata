  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                            #  Line  RIP   Bytes  Opcode              
.target:                          #        0     0      OPC=<label>         
  movq $0xfffffffffffffffd, %r9   #  1     0     10     OPC=movq_r64_imm64  
  movq %rbx, %r8                  #  2     0xa   3      OPC=movq_r64_r64    
  callq .move_064_128_r8_r9_xmm3  #  3     0xd   5      OPC=callq_label     
  vmovq %xmm3, %xmm1              #  4     0x12  4      OPC=vmovq_xmm_xmm   
  retq                            #  5     0x16  1      OPC=retq            
                                                                            
.size target, .-target
