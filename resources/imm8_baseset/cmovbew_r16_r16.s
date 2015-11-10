  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                 #  Line  RIP   Bytes  Opcode               
.target:               #        0     0      OPC=<label>          
  movzbl %bl, %esi     #  1     0     3      OPC=movzbl_r32_r8    
  setna %sil           #  2     0x3   4      OPC=setna_r8         
  popcntl %esi, %r10d  #  3     0x7   5      OPC=popcntl_r32_r32  
  xchgw %bx, %cx       #  4     0xc   3      OPC=xchgw_r16_r16    
  cmovew %cx, %bx      #  5     0xf   4      OPC=cmovew_r16_r16   
  retq                 #  6     0x13  1      OPC=retq             
                                                                  
.size target, .-target
