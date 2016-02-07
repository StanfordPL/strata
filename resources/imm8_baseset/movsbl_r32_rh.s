  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                     #  Line  RIP   Bytes  Opcode             
.target:                   #        0     0      OPC=<label>        
  xorw %r8w, %r8w          #  1     0     4      OPC=xorw_r16_r16   
  callq .read_zf_into_rbx  #  2     0x4   5      OPC=callq_label    
  xchgb %ah, %bl           #  3     0x9   2      OPC=xchgb_r8_rh    
  movsbl %bl, %eax         #  4     0xb   3      OPC=movsbl_r32_r8  
  xchgl %ebx, %eax         #  5     0xe   2      OPC=xchgl_r32_r32  
  retq                     #  6     0x10  1      OPC=retq           
                                                                    
.size target, .-target
