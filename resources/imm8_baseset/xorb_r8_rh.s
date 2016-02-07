  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                            #  Line  RIP  Bytes  Opcode             
.target:                          #        0    0      OPC=<label>        
  movsbw %ah, %dx                 #  1     0    4      OPC=movsbw_r16_rh  
  callq .move_016_008_dx_r8b_r9b  #  2     0x4  5      OPC=callq_label    
  xorb %r8b, %bl                  #  3     0x9  3      OPC=xorb_r8_r8     
  retq                            #  4     0xc  1      OPC=retq           
                                                                          
.size target, .-target
