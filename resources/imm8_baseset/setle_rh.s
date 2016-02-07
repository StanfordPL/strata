  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                     #  Line  RIP   Bytes  Opcode             
.target:                   #        0     0      OPC=<label>        
  callq .read_zf_into_rcx  #  1     0     5      OPC=callq_label    
  movzbw %cl, %di          #  2     0x5   4      OPC=movzbw_r16_r8  
  setnge %r14b             #  3     0x9   4      OPC=setnge_r8      
  orb %r14b, %dil          #  4     0xd   3      OPC=orb_r8_r8      
  seta %ah                 #  5     0x10  3      OPC=seta_rh        
  retq                     #  6     0x13  1      OPC=retq           
                                                                    
.size target, .-target
