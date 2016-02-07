  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                   #  Line  RIP  Bytes  Opcode               
.target:                 #        0    0      OPC=<label>          
  xchgl %ebx, %ecx       #  1     0    2      OPC=xchgl_r32_r32    
  setns %dl              #  2     0x2  3      OPC=setns_r8         
  callq .write_dl_to_zf  #  3     0x5  5      OPC=callq_label      
  cmovnel %ecx, %ebx     #  4     0xa  3      OPC=cmovnel_r32_r32  
  retq                   #  5     0xd  1      OPC=retq             
                                                                   
.size target, .-target
