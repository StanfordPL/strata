  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    5 bytes

# Text                   #  Line  RIP  Bytes  Opcode               
.target:                 #        0    0      OPC=<label>          
  setpe %dl              #  1     0    3      OPC=setpe_r8         
  callq .write_dl_to_zf  #  2     0x3  5      OPC=callq_label      
  cmovnzq %rcx, %rbx     #  3     0x8  4      OPC=cmovnzq_r64_r64  
  retq                   #  4     0xc  1      OPC=retq             
                                                                   
.size target, .-target
