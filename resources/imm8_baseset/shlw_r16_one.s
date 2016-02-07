  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text            #  Line  RIP  Bytes  Opcode             
.target:          #        0    0      OPC=<label>        
  xchgw %bx, %bx  #  1     0    3      OPC=xchgw_r16_r16  
  salw $0x1, %bx  #  2     0x3  3      OPC=salw_r16_one   
  retq            #  3     0x6  1      OPC=retq           
                                                          
.size target, .-target
