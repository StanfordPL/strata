  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                               #  Line  RIP   Bytes  Opcode             
.target:                             #        0     0      OPC=<label>        
  callq .read_cf_into_rbx            #  1     0     5      OPC=callq_label    
  callq .move_064_032_rbx_r10d_r11d  #  2     0x5   5      OPC=callq_label    
  movsbw %r10b, %r10w                #  3     0xa   5      OPC=movsbw_r16_r8  
  callq .move_008_016_r10b_r11b_cx   #  4     0xf   5      OPC=callq_label    
  sarq %cl, %rbx                     #  5     0x14  3      OPC=sarq_r64_cl    
  sete %ah                           #  6     0x17  3      OPC=sete_rh        
  retq                               #  7     0x1a  1      OPC=retq           
                                                                              
.size target, .-target
