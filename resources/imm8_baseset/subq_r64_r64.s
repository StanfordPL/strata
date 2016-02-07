  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                               #  Line  RIP   Bytes  Opcode             
.target:                             #        0     0      OPC=<label>        
  vmovq %rcx, %xmm1                  #  1     0     5      OPC=vmovq_xmm_r64  
  callq .move_byte_5_of_ymm1_to_r8b  #  2     0x5   5      OPC=callq_label    
  andb %r8b, %r8b                    #  3     0xa   3      OPC=andb_r8_r8     
  sbbq %rcx, %rbx                    #  4     0xd   3      OPC=sbbq_r64_r64   
  retq                               #  5     0x10  1      OPC=retq           
                                                                              
.size target, .-target
