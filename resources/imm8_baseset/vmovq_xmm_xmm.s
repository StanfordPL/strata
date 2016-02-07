  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                              #  Line  RIP   Bytes  Opcode             
.target:                            #        0     0      OPC=<label>        
  callq .move_128_064_xmm2_r12_r13  #  1     0     5      OPC=callq_label    
  vzeroall                          #  2     0x5   3      OPC=vzeroall       
  callq .move_128_064_xmm3_r8_r9    #  3     0x8   5      OPC=callq_label    
  xchgl %r13d, %r9d                 #  4     0xd   3      OPC=xchgl_r32_r32  
  callq .move_064_128_r12_r13_xmm1  #  5     0x10  5      OPC=callq_label    
  retq                              #  6     0x15  1      OPC=retq           
                                                                             
.size target, .-target
