  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text           #  Line  RIP  Bytes  Opcode            
.target:         #        0    0      OPC=<label>       
  notw %cx       #  1     0    3      OPC=notw_r16      
  stc            #  2     0x3  1      OPC=stc           
  adcw %cx, %bx  #  3     0x4  3      OPC=adcw_r16_r16  
  cmc            #  4     0x7  1      OPC=cmc           
  retq           #  5     0x8  1      OPC=retq          
                                                        
.size target, .-target
