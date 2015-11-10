  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                   #  Line  RIP   Bytes  Opcode             
.target:                 #        0     0      OPC=<label>        
  movsbl %cl, %r10d      #  1     0     4      OPC=movsbl_r32_r8  
  movzbq %bl, %r8        #  2     0x4   4      OPC=movzbq_r64_r8  
  subq %r10, %r8         #  3     0x8   3      OPC=subq_r64_r64   
  movb %r8b, %bl         #  4     0xb   3      OPC=movb_r8_r8     
  xaddb %r8b, %r10b      #  5     0xe   4      OPC=xaddb_r8_r8    
  callq .set_szp_for_bl  #  6     0x12  5      OPC=callq_label    
  retq                   #  7     0x17  1      OPC=retq           
                                                                  
.size target, .-target
