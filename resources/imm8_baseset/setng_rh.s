  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                     #  Line  RIP   Bytes  Opcode               
.target:                   #        0     0      OPC=<label>          
  callq .read_zf_into_rcx  #  1     0     5      OPC=callq_label      
  setl %ch                 #  2     0x5   3      OPC=setl_rh          
  popcntl %ecx, %r14d      #  3     0x8   5      OPC=popcntl_r32_r32  
  seta %ah                 #  4     0xd   3      OPC=seta_rh          
  retq                     #  5     0x10  1      OPC=retq             
                                                                      
.size target, .-target
