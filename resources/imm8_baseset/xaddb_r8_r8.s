  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                               #  Line  RIP   Bytes  Opcode             
.target:                             #        0     0      OPC=<label>        
  movsbq %bl, %rdx                   #  1     0     4      OPC=movsbq_r64_r8  
  callq .move_032_016_edx_r12w_r13w  #  2     0x4   5      OPC=callq_label    
  clc                                #  3     0x9   1      OPC=clc            
  adcb %cl, %bl                      #  4     0xa   2      OPC=adcb_r8_r8     
  callq .set_szp_for_bl              #  5     0xc   5      OPC=callq_label    
  callq .move_016_032_r12w_r13w_ecx  #  6     0x11  5      OPC=callq_label    
  retq                               #  7     0x16  1      OPC=retq           
                                                                              
.size target, .-target
