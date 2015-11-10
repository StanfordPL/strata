  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                               #  Line  RIP   Bytes  Opcode                 
.target:                             #        0     0      OPC=<label>            
  callq .move_128_064_xmm1_r8_r9     #  1     0     5      OPC=callq_label        
  callq .move_r9b_to_byte_0_of_ymm1  #  2     0x5   5      OPC=callq_label        
  movslq %ebx, %r10                  #  3     0xa   3      OPC=movslq_r64_r32     
  cvtsi2ssq %r10, %xmm1              #  4     0xd   5      OPC=cvtsi2ssq_xmm_r64  
  retq                               #  5     0x12  1      OPC=retq               
                                                                                  
.size target, .-target
