  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    6 bytes

# Text                            #  Line  RIP   Bytes  Opcode                 
.target:                          #        0     0      OPC=<label>            
  callq .move_128_064_xmm2_r8_r9  #  1     0     5      OPC=callq_label        
  addb %bl, %r8b                  #  2     0x5   3      OPC=addb_r8_r8         
  vzeroall                        #  3     0x8   3      OPC=vzeroall           
  callq .move_064_128_r8_r9_xmm1  #  4     0xb   5      OPC=callq_label        
  cvtsi2ssq %rbx, %xmm1           #  5     0x10  5      OPC=cvtsi2ssq_xmm_r64  
  retq                            #  6     0x15  1      OPC=retq               
                                                                               
.size target, .-target
