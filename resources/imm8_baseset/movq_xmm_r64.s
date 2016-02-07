  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                               #  Line  RIP   Bytes  Opcode              
.target:                             #        0     0      OPC=<label>         
  vmovq %rbx, %xmm0                  #  1     0     5      OPC=vmovq_xmm_r64   
  movdqa %xmm0, %xmm1                #  2     0x5   4      OPC=movdqa_xmm_xmm  
  callq .move_byte_9_of_ymm1_to_r8b  #  3     0x9   5      OPC=callq_label     
  callq .move_r8b_to_byte_8_of_ymm1  #  4     0xe   5      OPC=callq_label     
  retq                               #  5     0x13  1      OPC=retq            
                                                                               
.size target, .-target
