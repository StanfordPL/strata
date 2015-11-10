  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text              #  Line  RIP  Bytes  Opcode              
.target:            #        0    0      OPC=<label>         
  movsbw %ah, %ax   #  1     0    4      OPC=movsbw_r16_rh   
  movzwl %ax, %ebp  #  2     0x4  3      OPC=movzwl_r32_r16  
  adcb %bpl, %al    #  3     0x7  3      OPC=adcb_r8_r8      
  movb %al, %ah     #  4     0xa  2      OPC=movb_rh_r8      
  retq              #  5     0xc  1      OPC=retq            
                                                             
.size target, .-target
