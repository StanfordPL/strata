  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                     #  Line  RIP   Bytes  Opcode             
.target:                   #        0     0      OPC=<label>        
  callq .clear_cf          #  1     0     5      OPC=callq_label    
  setbe %r15b              #  2     0x5   4      OPC=setbe_r8       
  callq .read_cf_into_rbx  #  3     0x9   5      OPC=callq_label    
  movzbl %r15b, %eax       #  4     0xe   4      OPC=movzbl_r32_r8  
  setz %ah                 #  5     0x12  3      OPC=setz_rh        
  xchgb %bh, %bl           #  6     0x15  2      OPC=xchgb_r8_rh    
  xchgl %eax, %ebx         #  7     0x17  1      OPC=xchgl_r32_eax  
  retq                     #  8     0x18  1      OPC=retq           
                                                                    
.size target, .-target
