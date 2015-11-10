  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                               #  Line  RIP   Bytes  Opcode             
.target:                             #        0     0      OPC=<label>        
  callq .read_sf_into_rcx            #  1     0     5      OPC=callq_label    
  callq .move_064_032_rcx_r12d_r13d  #  2     0x5   5      OPC=callq_label    
  callq .move_008_016_r12b_r13b_dx   #  3     0xa   5      OPC=callq_label    
  movw %dx, %r9w                     #  4     0xf   4      OPC=movw_r16_r16   
  movsbw %r9b, %ax                   #  5     0x13  5      OPC=movsbw_r16_r8  
  xaddb %ah, %cl                     #  6     0x18  3      OPC=xaddb_r8_rh    
  retq                               #  7     0x1b  1      OPC=retq           
                                                                              
.size target, .-target
