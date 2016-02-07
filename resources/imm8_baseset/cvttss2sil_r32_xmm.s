  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                     #  Line  RIP   Bytes  Opcode                   
.target:                   #        0     0      OPC=<label>              
  xorl %ebx, %ebx          #  1     0     2      OPC=xorl_r32_r32         
  vcvttss2sil %xmm1, %ebp  #  2     0x2   4      OPC=vcvttss2sil_r32_xmm  
  popcntw %bp, %r8w        #  3     0x6   6      OPC=popcntw_r16_r16      
  incb %bl                 #  4     0xc   2      OPC=incb_r8              
  cmovnbl %ebp, %ebx       #  5     0xe   3      OPC=cmovnbl_r32_r32      
  retq                     #  6     0x11  1      OPC=retq                 
                                                                          
.size target, .-target
