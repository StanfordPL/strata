  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                   #  Line  RIP  Bytes  Opcode               
.target:                 #        0    0      OPC=<label>          
  setnae %dl             #  1     0    3      OPC=setnae_r8        
  callq .write_dl_to_zf  #  2     0x3  5      OPC=callq_label      
  xchgb %cl, %cl         #  3     0x8  2      OPC=xchgb_r8_r8      
  cmovnzl %ecx, %ebx     #  4     0xa  3      OPC=cmovnzl_r32_r32  
  retq                   #  5     0xd  1      OPC=retq             
                                                                   
.size target, .-target
