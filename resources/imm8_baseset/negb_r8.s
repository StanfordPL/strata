  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                   #  Line  RIP   Bytes  Opcode             
.target:                 #        0     0      OPC=<label>        
  movzbl %bl, %r14d      #  1     0     4      OPC=movzbl_r32_r8  
  negq %r14              #  2     0x4   3      OPC=negq_r64       
  xaddb %bl, %r14b       #  3     0x7   4      OPC=xaddb_r8_r8    
  callq .set_szp_for_bl  #  4     0xb   5      OPC=callq_label    
  retq                   #  5     0x10  1      OPC=retq           
                                                                  
.size target, .-target
