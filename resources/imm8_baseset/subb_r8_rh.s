  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    3 bytes

# Text                     #  Line  RIP   Bytes  Opcode             
.target:                   #        0     0      OPC=<label>        
  movsbq %bl, %r12         #  1     0     4      OPC=movsbq_r64_r8  
  xchgb %ah, %bl           #  2     0x4   2      OPC=xchgb_r8_rh    
  subb %bl, %r12b          #  3     0x6   3      OPC=subb_r8_r8     
  callq .read_of_into_rbx  #  4     0x9   5      OPC=callq_label    
  xchgl %ebx, %r12d        #  5     0xe   3      OPC=xchgl_r32_r32  
  retq                     #  6     0x11  1      OPC=retq           
                                                                    
.size target, .-target
