  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                              #  Line  RIP   Bytes  Opcode              
.target:                            #        0     0      OPC=<label>         
  setnl %r13b                       #  1     0     4      OPC=setnl_r8        
  callq .read_zf_into_rbx           #  2     0x4   5      OPC=callq_label     
  movzbw %r13b, %r14w               #  3     0x9   5      OPC=movzbw_r16_r8   
  callq .move_byte_7_of_rbx_to_r8b  #  4     0xe   5      OPC=callq_label     
  movzbl %r8b, %r15d                #  5     0x13  4      OPC=movzbl_r32_r8   
  movswq %r14w, %rbx                #  6     0x17  4      OPC=movswq_r64_r16  
  cmovzq %r15, %rbx                 #  7     0x1b  4      OPC=cmovzq_r64_r64  
  retq                              #  8     0x1f  1      OPC=retq            
                                                                              
.size target, .-target
