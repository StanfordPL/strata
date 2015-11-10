  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text               #  Line  RIP  Bytes  Opcode             
.target:             #        0    0      OPC=<label>        
  movzbw %ah, %cx    #  1     0    4      OPC=movzbw_r16_rh  
  movzbl %cl, %r12d  #  2     0x4  4      OPC=movzbl_r32_r8  
  xaddb %r12b, %bl   #  3     0x8  4      OPC=xaddb_r8_r8    
  retq               #  4     0xc  1      OPC=retq           
                                                             
.size target, .-target
