  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text              #  Line  RIP  Bytes  Opcode               
.target:            #        0    0      OPC=<label>          
  xchgw %cx, %bx    #  1     0    3      OPC=xchgw_r16_r16    
  callq .clear_zf   #  2     0x3  5      OPC=callq_label      
  cmovlew %cx, %bx  #  3     0x8  4      OPC=cmovlew_r16_r16  
  retq              #  4     0xc  1      OPC=retq             
                                                              
.size target, .-target
