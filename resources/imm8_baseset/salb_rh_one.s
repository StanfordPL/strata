  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                     #  Line  RIP   Bytes  Opcode              
.target:                   #        0     0      OPC=<label>         
  xorq %rbx, %rbx          #  1     0     3      OPC=xorq_r64_r64    
  callq .read_cf_into_rcx  #  2     0x3   5      OPC=callq_label     
  movb %ah, %cl            #  3     0x8   2      OPC=movb_r8_rh      
  movswq %cx, %r9          #  4     0xa   4      OPC=movswq_r64_r16  
  addb %r9b, %cl           #  5     0xe   3      OPC=addb_r8_r8      
  xchgb %ah, %cl           #  6     0x11  2      OPC=xchgb_r8_rh     
  retq                     #  7     0x13  1      OPC=retq            
                                                                     
.size target, .-target
