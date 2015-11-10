  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text               #  Line  RIP  Bytes  Opcode             
.target:             #        0    0      OPC=<label>        
  movsbl %bl, %r10d  #  1     0    4      OPC=movsbl_r32_r8  
  movsbw %ah, %sp    #  2     0x4  4      OPC=movsbw_r16_rh  
  andw %r10w, %sp    #  3     0x8  4      OPC=andw_r16_r16   
  movb %spl, %bl     #  4     0xc  3      OPC=movb_r8_r8     
  retq               #  5     0xf  1      OPC=retq           
                                                             
.size target, .-target
