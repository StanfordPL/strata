  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                            #  Line  RIP  Bytes  Opcode           
.target:                          #        0    0      OPC=<label>      
  shrq %cl, %rbx                  #  1     0    3      OPC=shrq_r64_cl  
  callq .move_016_008_bx_r8b_r9b  #  2     0x3  5      OPC=callq_label  
  sarb $0x1, %r8b                 #  3     0x8  3      OPC=sarb_r8_one  
  retq                            #  4     0xb  1      OPC=retq         
                                                                        
.size target, .-target
