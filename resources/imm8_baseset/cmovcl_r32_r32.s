  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                #  Line  RIP  Bytes  Opcode               
.target:              #        0    0      OPC=<label>          
  cmovnbl %ebx, %ecx  #  1     0    3      OPC=cmovnbl_r32_r32  
  setae %bh           #  2     0x3  4      OPC=setae_rh         
  xchgl %ebx, %ecx    #  3     0x7  2      OPC=xchgl_r32_r32    
  retq                #  4     0x9  1      OPC=retq             
                                                                
.size target, .-target
