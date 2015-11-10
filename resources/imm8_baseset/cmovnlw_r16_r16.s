  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text              #  Line  RIP  Bytes  Opcode               
.target:            #        0    0      OPC=<label>          
  setnge %spl       #  1     0    4      OPC=setnge_r8        
  sarb $0x1, %spl   #  2     0x4  3      OPC=sarb_r8_one      
  cmovncw %cx, %bx  #  3     0x7  4      OPC=cmovncw_r16_r16  
  retq              #  4     0xb  1      OPC=retq             
                                                              
.size target, .-target
