  .text
  .globl target
  .type target, @function

#! file-offset 0
#! rip-offset  0
#! capacity    4 bytes

# Text                            #  Line  RIP   Bytes  Opcode              
.target:                          #        0     0      OPC=<label>         
  movzbw %bl, %r15w               #  1     0     5      OPC=movzbw_r16_r8   
  movswl %r15w, %ecx              #  2     0x5   4      OPC=movswl_r32_r16  
  callq .move_016_008_cx_r8b_r9b  #  3     0x9   5      OPC=callq_label     
  xchgb %ah, %cl                  #  4     0xe   2      OPC=xchgb_r8_rh     
  movzbl %r8b, %r12d              #  5     0x10  4      OPC=movzbl_r32_r8   
  addb %cl, %r12b                 #  6     0x14  3      OPC=addb_r8_r8      
  movzwq %r12w, %rbx              #  7     0x17  4      OPC=movzwq_r64_r16  
  retq                            #  8     0x1b  1      OPC=retq            
                                                                            
.size target, .-target
