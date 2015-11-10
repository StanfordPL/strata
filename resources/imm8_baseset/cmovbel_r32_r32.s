  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                #  Line  RIP  Bytes  Opcode               
.target:              #        0    0      OPC=<label>          
  sete %bpl           #  1     0    4      OPC=sete_r8          
  adcb %bpl, %bpl     #  2     0x4  3      OPC=adcb_r8_r8       
  cmovnel %ecx, %ebx  #  3     0x7  3      OPC=cmovnel_r32_r32  
  retq                #  4     0xa  1      OPC=retq             
                                                                
.size target, .-target
